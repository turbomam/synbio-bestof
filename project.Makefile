## Add your own custom Makefile targets here

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
