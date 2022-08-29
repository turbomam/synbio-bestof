## Add your own custom Makefile targets here

RUN=poetry run

schemasheet_key=1OMPPggJNP-4vom020KDVSwvxLqH5WfTH7k3GceL9IgI # synbio_bottom_up_cleanroom
credentials_file=local/felix-sheets-4d1f37aa312b.json
schema_path=src/schema/synbio-bestof.yaml

synbio-all: synbio-clean \
	target/seq_datum.json target/person_datum.json target/SeqCollection.yaml \
	target/felix_dump.db target/synbio.sql target/omnicollection.yaml

# target/felix_parts_seq_for_schema.tsv
#  target/synbio-bestof.db target/felix_modifcation_parts.tsv

synbio-clean:
	rm -rf target/*
	rm -rf local/felix_dump.db
	rm -rf src/schema/*
	mkdir -p target
	mkdir -p logs

PHONY:.cogs squeaky-clean synbio-clean
.cogs:
	poetry run cogs connect -k $(schemasheet_key) -c $(credentials_file)

# requires fetch step for satisfying dependencies?
.cogs/tracked/%: .cogs
	poetry run cogs add $(subst .tsv,,$(subst .cogs/tracked/,,$@))
	poetry run cogs fetch
	sleep 10

squeaky-clean: synbio-clean
	rm -rf .cogs

# generate a LinkML schema from Google Sheets
src/schema/synbio-bestof.yaml: .cogs/tracked/schema.tsv .cogs/tracked/prefixes.tsv .cogs/tracked/slots.tsv \
.cogs/tracked/classes.tsv .cogs/tracked/enums.tsv
	poetry run cogs fetch
	poetry run sheets2linkml $^ > $@

# "validate" the schema, which was just built from Google sheets, with gen-linkml
src/schema/synbio-bestof-validated.yaml: $(schema_path)
	# are there any validations that this misses?
	poetry run gen-yaml $< 1> $@ 2>> logs/synbio-bestof-validation.log

# other linkml sql-related gen- commands
#   gen-sqla           gen-sqlddl         gen-sqlddl-legacy  gen-sqltables

# convert the schema to a sql script that creates an empty database
#   not actually required for subsequent dumping-toSQLite steps
target/synbio.sql: $(schema_path)
	poetry run gen-sqlddl $< 1> $@ 2>> target/make.log

# illustrates converting one mock sequence from yaml to json with the schema's guidance
target/seq_datum.json: data/seq_datum.yaml src/schema/synbio-bestof-validated.yaml
	poetry run linkml-convert --output $@ --target-class Ntseq --schema $(schema_path) $<

# illustrates converting one mock person from yaml to json with the schema's guidance
target/person_datum.json: data/person_datum.yaml src/schema/synbio-bestof-validated.yaml
	poetry run linkml-convert --output $@ --target-class Person --schema $(schema_path) $<

# illustrates converting a collection of mock sequence data from TSV to a YAML, with the schema's guidance
target/SeqCollection.yaml: data/SeqCollection.tsv src/schema/synbio-bestof-validated.yaml
	poetry run linkml-convert \
		--output $@ \
		--target-class SeqCollection \
		--index-slot sequences \
		--schema $(schema_path) $<

# extracts some FELIX data from the Celniker Postgres and saves locally as a SQLite database
# requires ssh tunneling and or database credentials
# like ssh -L 1111:dbhost:5432 -o PreferredAuthentications=password -o PubkeyAuthentication=no user@sshhost.lbl.gov
# todo parameterize the output database
# removing synbio-clean prereq
# make sure that it is triggered before this rule is run
target/felix_dump.db:
	- poetry run sh utils/pgsql2sqlite.sh mam 1111 parts,parts_sequences,modifications

 # IF00284_adh2_202036bp_chrXIII-chrII_transposition is 202036 nt long
# the next longest sequences are ~ 49k long
target/felix_parts_seq_for_schema.tsv: target/felix_dump.db
	sqlite3 $< \
		".headers on" \
		".mode tabs" \
		'select "id" as seq_id, part_id, file, seq_name, "type" as seq_type, date_added, sequence from parts_sequences where length(sequence) < 131072;' \
		"" > $@

target/felix_parts_seq_for_schema.yaml: target/felix_parts_seq_for_schema.tsv
	poetry run linkml-convert \
		--output $@ \
		--target-class OmniCollection \
		--index-slot sequences \
		--schema $(schema_path) $<
		
target/omnicollection.yaml: target/felix_parts_seq_for_schema.yaml
	# generate and add modifications... requires use of seq2ids output?
	cat $< > $@

target/omnicollection.db: target/omnicollection.yaml
	poetry run linkml-sqldb dump \
		--schema $(schema_path) \
		--target-class OmniCollection \
		--db $@ $<
	sqlite3 $@ "select * from Ntseq" ""



# todo
# RuntimeError: Multiple potential target classes found:
# ['Part', 'Modification', 'SeqCollection']. Please specify a target using --target_class
# or by adding tree_root: true to the relevant class in the schema.
#		--target-class SeqCollection \
#		--index-slot sequences \

#target/synbio-bestof.db: target/SeqCollection.yaml src/schema/synbio-bestof-validated.yaml
#	poetry run linkml-sqldb dump \
#		--schema $(schema_path) \
#		--target-class SeqCollection \
#		--db $@ $<
#	sqlite3 $@ "select * from Ntseq" ""


target/synbio-bestof.db: target/felix_parts_seq_for_schema.tsv src/schema/synbio-bestof-validated.yaml
#	# moves data from the TSV file into the SQLite database
#	# subsequent linkml- operation on the same SQLite database would overwrite
#	# the data in the database with the data in the TSV file
#	# todo: generate a single YAML file that contains data about all relevant classes
#	#   and then just dump that
#	poetry run linkml-sqldb dump \
#		--schema $(schema_path) \
#		--target-class SeqCollection \
#		--index-slot sequences \
#		--db $@ target/felix_parts_seq_for_schema.tsv
#	poetry run linkml-convert \
#		--output target/merged_modification_data.yaml \
#		--target-class ModCollection \
#		--index-slot modifications \
#		--schema target/synbio.yaml target/merged_modification_data.tsv
#	cat target/felix_parts_seq_for_schema.yaml target/merged_modification_data.yaml > target/omnicollection.yaml
#	poetry run linkml-sqldb dump \
#		--schema target/synbio.yaml \
#		--target-class SeqCollection \
#		--index-slot sequences \
#		--db $@ target/felix_parts_seq_for_schema.tsv
#	sqlite3 $@ \
#		".headers on" \
#		".mode tabs" \
#		"select * from Ntseq limit 9" ""
#	poetry run linkml-sqldb load \
#		--schema target/synbio.yaml \
#		--target-class SeqCollection \
#		--index-slot sequences \
#		--db $@ \
#		--output target/SeqCollection.yaml
#	poetry run linkml-sqldb dump \
#		--schema target/synbio.yaml \
#		--target-class ModCollection \
#		--index-slot modifications \
#		--db $@ target/merged_modification_data.tsv
#	sqlite3 $@ \
#		".headers on" \
#		".mode tabs" \
#		"select * from Modification limit 9" ""
#	poetry run linkml-sqldb load \
#		--schema target/synbio.yaml \
#		--target-class ModCollection \
#		--index-slot modifications \
#		--db $@ \
#		--output target/ModCollection.yaml

target/synbio.db: target/omnicollection.yaml
	cat target/felix_parts_seq_for_schema.yaml target/merged_modification_data.yaml > target/omnicollection.yaml
	poetry run linkml-sqldb dump \
		--schema target/synbio.yaml \
		--target-class OmniCollection \
		--db $@ $<

# id|part_id|file|seq_name|type|date_added|sequence
# seq_id|part_id|file|seq_name|seq_type|date_added|sequence|SeqCollection_id

#select "id" as seq_id, part_id, file, seq_name, "type" as seq_type, date_added, sequence from parts_sequences limit 3;

# switch to l2s supplement from linkml abuse
#target/class.tsv: src/schema/synbio-bestof-validated.yaml
#	poetry run linkml2sheets -s $(schema_path) l2s_templates/*tsv -d target

# PRETTY GOOD SCHEMA ROUND TRIPPING

target/dumps/%.tsv:
	# @echo $(basename $(notdir $@))
	psql \
		-h localhost \
		-p 1111 \
		-d felix \
		-U mam \
		-c "\copy (select * from $(basename $(notdir $@))) TO 'target/dumps/$(basename $(notdir $@)).tsv' CSV HEADER DELIMITER E'\t';"

# whats a good way to do customized dumps like this?
# for example, we may want to rename some columns

target/dumps/manual/auth_user.tsv:
	psql \
		-h localhost \
		-p 1111 \
		-d felix \
		-U mam \
		-c "\copy (select date_joined, email, first_name, id, is_staff, initcap(cast(is_superuser as text)) as is_superuser, last_name, username from $(basename $(notdir $@))) TO '$@' CSV HEADER DELIMITER E'\t';"

target/dumps/manual/auth_user_schema.yaml: target/dumps/manual/auth_user.tsv
	head -n 4 $<
	$(RUN) schemauto generalize-tsv \
		--annotator bioportal: \
		--output $@ \
		--schema-name $(basename $(notdir $@)) \
		--class-name $(basename $(notdir $@)) $<

.PHONY: clean_dumps dumps

clean_dumps:
	rm -rf target/dumps/*
	rm -rf target/postgres_dump_schema.db
	mkdir -p target/dumps/manual

target/dumps/%_schema.yaml: target/dumps/%.tsv
	head -n 4 $<
	$(RUN) schemauto generalize-tsv \
		--annotator bioportal: \
		--output $@ \
		--schema-name $(basename $(notdir $@)) \
		--class-name $(basename $(notdir $@)) $<

# target/dumps/auth_user.tsv target/dumps/auth_user_schema.yaml \

dumps: clean_dumps target/dumps/postgres_dump_schema.yaml \
target/dumps/manual/auth_user.tsv target/dumps/manual/auth_user_schema.yaml \
target/dumps/modifications.tsv target/dumps/modifications_schema.yaml \
target/dumps/parts.tsv target/dumps/parts_schema.yaml

target/postgres_dump.db:
	- $(RUN) sh utils/pgsql2sqlite.sh mam 1111 auth_user,biological_samples,external_urls,genomes,modifications,parts,parts_parameters,parts_sequences,performer_aliquots,plasmids,proteins,selection_markers,species,sub_parts,sub_parts_attributes $(basename $(notdir $@))

target/dumps/postgres_dump_schema.yaml: target/postgres_dump.db
	$(RUN) schemauto import-sql \
		--output $@ \
		--schema-name $(basename $(notdir $@)) $<
	# how to re-implement as yq or something else more graceful than sed?
	sed -i.bak 's/auth_user/Person/' $@
	sed -i.bak 's/modifications:/Modification:/' $@
	# this doesn't delete any password data that might have been extracted from the database in other steps
	yq 'del(.classes.Person.attributes.password)' -i $@
	yq 'del(.classes.Person.attributes.last_login)' -i $@
	yq 'del(.classes.Person.attributes.is_active)' -i $@
	# capitalize class names
	# convert some is... integer slots to boolean
	# generalize attributes to slots
	# add Database class and related slots
	# add some imports

# not currently modeling highly variable attributes like is_active or last_login
# not currently modeling site-specific file paths
# all ids are prefixed
# no negative ids

#src/schema/synbio_bestof.yaml:
#	$(RUN) schemauto import-owl \
#		--output $@ target/synbio.ofn
#	sed -E -i.bak 's/multivalued: true//' src/schema/synbio_bestof.yaml
#	sed -E -i.bak 's/nmsfe/synbio/' src/schema/synbio_bestof.yaml
#	sed -E -i.bak 's/xsd:boolean/boolean/' src/schema/synbio_bestof.yaml
#	sed -E -i.bak 's/xsd:date/date/' src/schema/synbio_bestof.yaml
#	sed -E -i.bak 's/xsd:string/string/' src/schema/synbio_bestof.yaml
#	rm -rf $@.bak
#	yq --inplace '.classes.Organism.slot_usage.id.pattern = "^organism:"' $@
#	yq --inplace '.classes.Person.slot_usage.id.pattern = "^person:"' $@
#	yq --inplace '.default_range = "string"' $@
#	yq --inplace '.slots.organism_set.inlined_as_list = true' $@
#	yq --inplace '.slots.organism_set.multivalued = true' $@
#	yq --inplace '.slots.person_set.inlined_as_list = true' $@
#	yq --inplace '.slots.person_set.multivalued = true' $@
##	yq --inplace '.prefixes.dcterms = "http://purl.org/dc/terms/"' $@
##	yq --inplace '.prefixes.skos = "http://www.w3.org/2004/02/skos/core#"' $@

# ---

current_clean:
	rm -rf target/*.json  target/*.tsv  target/*_data.yaml target/*.bak


# ---

create_person_view:
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		-f sql/person_freestanding_crete_view.sql

target/person_freestanding_select.tsv:
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		--no-align \
		--field-separator '	' \
		--no-align \
		--pset footer \
		-f sql/person_freestanding_select.sql \
		-o $@

target/person_data.yaml: target/person_freestanding_select.tsv src/schema/synbio_bestof.yaml
	$(RUN) linkml-convert \
		--output $@ --schema $(word 2,$^) \
		--target-class Database \
		--index-slot person_set $<

# ---

target/synbio.schema.json: src/schema/synbio_bestof.yaml
	$(RUN) gen-json-schema $< > $@

# ---

create_modifications_view:
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		-f sql/modifications_freestanding_create_view.sql

target/modifications_freestanding_select.tsv: create_modifications_view
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		--no-align \
		--field-separator '	' \
		--no-align \
		--pset footer \
		-f sql/modifications_freestanding_select.sql \
		-o $@

target/modification_data.yaml: target/modifications_freestanding_select.tsv
	$(RUN) linkml-convert \
		--output $@ --schema src/schema/synbio_bestof.yaml \
		--target-class Database \
		--index-slot modification_set target/modifications_freestanding_select.tsv


# ---

create_organism_view:
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		-f sql/organism_freestanding_create_view.sql


target/organism_freestanding_select.tsv: create_organism_view
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		--no-align \
		--field-separator '	' \
		--no-align \
		--pset footer \
		-f sql/organism_freestanding_select.sql \
		-o $@


target/organism_data.yaml: target/organism_freestanding_select.tsv
	$(RUN) linkml-convert \
		--output $@ --schema src/schema/synbio_bestof.yaml \
		--target-class Database \
		--index-slot organism_set target/organism_freestanding_select.tsv
	sed -E -i.bak 's/\|/\n  - /g' $@

# ---


create_strain_view:
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		-f sql/strain_freestanding_create_view.sql


target/strain_freestanding_select.tsv: create_strain_view
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		--no-align \
		--field-separator '	' \
		--no-align \
		--pset footer \
		-f sql/strain_freestanding_select.sql \
		-o $@


target/strain_data.yaml: target/strain_freestanding_select.tsv
	$(RUN) linkml-convert \
		--output $@ --schema src/schema/synbio_bestof.yaml \
		--target-class Database \
		--index-slot strain_set target/strain_freestanding_select.tsv
	sed -E -i.bak 's/\|/\n  - /g' $@

# ---


create_sequences_view:
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		-f sql/sequences_freestanding_create_view.sql


target/sequences_freestanding_select.tsv: create_sequences_view
	psql \
		-h localhost \
		-p 1111 \
		-U mam \
		-d felix \
		--no-align \
		--field-separator '	' \
		--no-align \
		--pset footer \
		-f sql/sequences_freestanding_select.sql \
		-o $@


target/sequence_data.yaml: target/sequences_freestanding_select.tsv
	$(RUN) linkml-convert \
		--output $@ --schema src/schema/synbio_bestof.yaml \
		--target-class Database \
		--index-slot sequence_set target/sequences_freestanding_select.tsv



# ---

target/combo_data.yaml: \
target/modification_data.yaml \
target/organism_data.yaml \
target/person_data.yaml \
target/sequence_data.yaml \
target/strain_data.yaml
	cat $^ > $@

target/combo_data.json: target/combo_data.yaml
	$(RUN) linkml-convert \
		--output $@ --target-class Database --schema src/schema/synbio_bestof.yaml $<

combo_validator: target/synbio.schema.json target/combo_data.json
	jsonschema -i $(word 2,$^) $<

#target/combo.db: target/combo.json src/schema/synbio_bestof.yaml
#	$(RUN) linkml-sqldb dump \
#		-s $(word 2,$^) \
#		-D $@ \
#		--target-class Database $<


# ---

#target/organism_data.json: data/organism_via_species_subset.tsv src/schema/synbio_bestof.yaml
#	$(RUN) linkml-convert \
#		--output $@ --schema $(word 2,$^) \
#		--target-class Database \
#		--index-slot organism_set $<

# ---

## looses too much
#target/synbio.ttl:
#	$(RUN) gen-owl \
#		--metadata-profile linkml \
#		--no-type-objects \
#		--no-metaclasses \
#		--no-add-ols-annotations \
#		--format ttl \
#		--no-metadata \
#		--output $@ src/schema/synbio_bestof.yaml
#
#target/synbio.ofn:
#	robot convert --input target/synbio.ttl --output $@

