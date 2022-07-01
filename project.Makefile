## Add your own custom Makefile targets here

schemasheet_key=1OMPPggJNP-4vom020KDVSwvxLqH5WfTH7k3GceL9IgI # synbio_bottom_up_cleanroom
credentials_file=local/felix-sheets-4d1f37aa312b.json

synbio-all: synbio-clean target/seq_datum.json target/person_datum.json target/SeqCollection.yaml \
target/felix_dump.db target/synbio.sql target/synbio-bestof.db target/felix_modifcation_parts.tsv

synbio-clean:
	rm -rf target/*
	rm -rf target/felix_dump.db

PHONY:.cogs squeaky-clean synbio-clean all
.cogs:
	poetry run cogs connect -k $(schemasheet_key) -c $(credentials_file)

# requires fetch step for satisfying dependencies?
.cogs/tracked/%: .cogs
	poetry run cogs add $(subst .tsv,,$(subst .cogs/tracked/,,$@))
	poetry run cogs fetch
	sleep 10

squeaky-clean: synbio-clean
	rm -rf .cogs

# .cogs/tracked/synbio.tsv
# .cogs/tracked/enums.tsv
target/synbio.yaml: .cogs/tracked/schema.tsv .cogs/tracked/prefixes.tsv .cogs/tracked/slots.tsv .cogs/tracked/classes.tsv .cogs/tracked/enums.tsv
	poetry run cogs fetch
	poetry run sheets2linkml $^ > $@

target/synbio_generated.yaml: target/synbio.yaml
	# are there any validations that this misses?
	poetry run gen-yaml $< 1> $@ 2>> target/make.log

# gen-sqla           gen-sqlddl         gen-sqlddl-legacy  gen-sqltables
target/synbio.sql: target/synbio.yaml
	poetry run gen-sqlddl $< 1> $@ 2>> target/make.log

target/seq_datum.json: data/seq_datum.yaml target/synbio_generated.yaml
	poetry run linkml-convert --output $@ --target-class Ntseq --schema target/synbio.yaml $<

target/person_datum.json: data/person_datum.yaml target/synbio_generated.yaml
	poetry run linkml-convert --output $@ --target-class Person --schema target/synbio.yaml $<

target/SeqCollection.yaml: data/SeqCollection.tsv target/synbio_generated.yaml
	poetry run linkml-convert \
		--output $@ \
		--target-class SeqCollection \
		--index-slot sequences \
		--schema target/synbio.yaml $<

# todo
# RuntimeError: Multiple potential target classes found:
# ['Part', 'Modification', 'SeqCollection']. Please specify a target using --target_class
# or by adding tree_root: true to the relevant class in the schema.
#		--target-class SeqCollection \
#		--index-slot sequences \

#target/synbio-bestof.db: target/SeqCollection.yaml target/synbio_generated.yaml
#	poetry run linkml-sqldb dump \
#		--schema target/synbio.yaml \
#		--target-class SeqCollection \
#		--db $@ $<
#	sqlite3 $@ "select * from Ntseq" ""

# todo parameterize the output database
# removing synbio-clean prereq
# make sure that it is triggered before this rue is run
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

target/felix_modifcation_parts.tsv: target/felix_dump.db
	sqlite3 $< < sql/felix_modifcation_parts.sql > $@

target/synbio-bestof.db: synbio-clean target/synbio.yaml target/synbio_generated.yaml \
target/felix_parts_seq_for_schema.tsv target/felix_modifcation_parts.tsv
	rm -rf target/Celniker_curations.tsv
	rm -rf target/blast_annotation_results.tsv
	rm -rf target/merged_modification_data.tsv
	cut \
		-f6,7,8,9,10,11,12,14,15,16 \
		/Users/MAM/Documents/gitrepos/seq2ids/target/filtered_part_characterization.tsv > target/blast_annotation_results.tsv
#	head target/blast_annotation_results.tsv
#	#ls -l /Volumes/GoogleDrive/Shared\ drives/IARPA\ Synbio\ Ontology
	poetry run python utils/get_curations.py
	poetry run python utils/merge_modification_data.py
	#head target/merged_modification_data.tsv
	poetry run linkml-convert \
		--output target/felix_parts_seq_for_schema.yaml \
		--target-class SeqCollection \
		--index-slot sequences \
		--schema target/synbio.yaml target/felix_parts_seq_for_schema.tsv
	poetry run linkml-convert \
		--output target/merged_modification_data.yaml \
		--target-class ModCollection \
		--index-slot modifications \
		--schema target/synbio.yaml target/merged_modification_data.tsv
	cat target/felix_parts_seq_for_schema.yaml target/merged_modification_data.yaml > target/omnicollection.yaml
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
	poetry run linkml-sqldb dump \
		--schema target/synbio.yaml \
		--target-class OmniCollection \
		--db $@ $<

# id|part_id|file|seq_name|type|date_added|sequence
# seq_id|part_id|file|seq_name|seq_type|date_added|sequence|SeqCollection_id

#select "id" as seq_id, part_id, file, seq_name, "type" as seq_type, date_added, sequence from parts_sequences limit 3;

# switch to l2s supplement from linkml abuse
#target/class.tsv: target/synbio_generated.yaml
#	poetry run linkml2sheets -s target/synbio.yaml l2s_templates/*tsv -d target

# PRETTY GOOD SCHEM ROUND TRIPPING
