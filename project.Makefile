## Add your own custom Makefile targets here

schemasheet_key=1OMPPggJNP-4vom020KDVSwvxLqH5WfTH7k3GceL9IgI # synbio_bottom_up_cleanroom
credentials_file=local/felix-sheets-4d1f37aa312b.json

synbio-all: clean all synbio-clean target/seq_datum.json target/person_datum.json target/SeqCollection.yaml \
local/felix_dump.db target/main.sql target/synbio-bestof.db

synbio-clean:
	rm -rf target/*
	rm -rf local/felix_dump.db
	mkdir -p target
	mkdir -p logs

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

# .cogs/tracked/main.tsv
# .cogs/tracked/enums.tsv
src/schema/synbio-bestof.yaml: .cogs/tracked/schema.tsv .cogs/tracked/prefixes.tsv .cogs/tracked/slots.tsv .cogs/tracked/classes.tsv .cogs/tracked/enums.tsv
	poetry run cogs fetch
	poetry run sheets2linkml $^ > $@

src/schema/synbio-bestof-validated.yaml: src/schema/synbio-bestof.yaml
	# are there any validations that this misses?
	poetry run gen-yaml $< 1> $@ 2>> logs/synbio-bestof-validation.log

# gen-sqla           gen-sqlddl         gen-sqlddl-legacy  gen-sqltables
target/main.sql: src/schema/synbio-bestof.yaml
	poetry run gen-sqlddl $< 1> $@ 2>> target/make.log

target/seq_datum.json: data/seq_datum.yaml src/schema/synbio-bestof-validated.yaml
	poetry run linkml-convert --output $@ --target-class Ntseq --schema src/schema/synbio-bestof.yaml $<

target/person_datum.json: data/person_datum.yaml src/schema/synbio-bestof-validated.yaml
	poetry run linkml-convert --output $@ --target-class Person --schema src/schema/synbio-bestof.yaml $<

target/SeqCollection.yaml: data/SeqCollection.tsv src/schema/synbio-bestof-validated.yaml
	poetry run linkml-convert \
		--output $@ \
		--target-class SeqCollection \
		--index-slot sequences \
		--schema src/schema/synbio-bestof.yaml $<

# todo
# RuntimeError: Multiple potential target classes found:
# ['Part', 'Modification', 'SeqCollection']. Please specify a target using --target_class
# or by adding tree_root: true to the relevant class in the schema.
#		--target-class SeqCollection \
#		--index-slot sequences \

#target/synbio-bestof.db: target/SeqCollection.yaml src/schema/synbio-bestof-validated.yaml
#	poetry run linkml-sqldb dump \
#		--schema src/schema/synbio-bestof.yaml \
#		--target-class SeqCollection \
#		--db $@ $<
#	sqlite3 $@ "select * from Ntseq" ""

# todo parameterize the output database
local/felix_dump.db: synbio-clean
	- poetry run sh utils/pgsql2sqlite.sh mam 1111 parts,parts_sequences,modifications

# IF00284_adh2_202036bp_chrXIII-chrII_transposition is 202036 nt long
# the next longest sequences are ~ 49k long
target/felix_parts_seq_for_schema.tsv: local/felix_dump.db
	sqlite3 $< \
		".headers on" \
		".mode tabs" \
		'select "id" as seq_id, part_id, file, seq_name, "type" as seq_type, date_added, sequence from parts_sequences where length(sequence) < 131072;' \
		"" > $@

target/synbio-bestof.db: target/felix_parts_seq_for_schema.tsv src/schema/synbio-bestof-validated.yaml
	poetry run linkml-sqldb dump \
		--schema src/schema/synbio-bestof.yaml \
		--target-class SeqCollection \
		--index-slot sequences \
		--db $@ $<
	sqlite3 $@ \
		".headers on" \
		".mode tabs" \
		"select * from Ntseq limit 9" ""

# id|part_id|file|seq_name|type|date_added|sequence
# seq_id|part_id|file|seq_name|seq_type|date_added|sequence|SeqCollection_id

#select "id" as seq_id, part_id, file, seq_name, "type" as seq_type, date_added, sequence from parts_sequences limit 3;

# switch to l2s supplement from linkml abuse
#target/class.tsv: src/schema/synbio-bestof-validated.yaml
#	poetry run linkml2sheets -s src/schema/synbio-bestof.yaml l2s_templates/*tsv -d target

