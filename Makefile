schemasheet_key=1OMPPggJNP-4vom020KDVSwvxLqH5WfTH7k3GceL9IgI # synbio_bottom_up_cleanroom
credentials_file=local/felix-sheets-4d1f37aa312b.json

all: clean target/seq_datum.json target/person_datum.json target/SeqCollection.yaml \
target/felix_dump.db target/main.sql target/synbio-bestof.db

clean:
	rm -rf target/*
	rm -rf local/felix_dump.db

PHONY:.cogs squeaky-clean all
.cogs:
	poetry run cogs connect -k $(schemasheet_key) -c $(credentials_file)

# requires fetch step for satisfying dependencies?
.cogs/tracked/%: .cogs
	poetry run cogs add $(subst .tsv,,$(subst .cogs/tracked/,,$@))
	poetry run cogs fetch
	sleep 10

squeaky-clean: clean
	rm -rf .cogs

# .cogs/tracked/main.tsv
# .cogs/tracked/enums.tsv
target/main.yaml: .cogs/tracked/schema.tsv .cogs/tracked/prefixes.tsv .cogs/tracked/slots.tsv .cogs/tracked/classes.tsv .cogs/tracked/enums.tsv
	poetry run cogs fetch
	poetry run sheets2linkml $^ > $@

target/main_generated.yaml: target/main.yaml
	# are there any validations that this misses?
	poetry run gen-yaml $< 1> $@ 2>> target/make.log

# gen-sqla           gen-sqlddl         gen-sqlddl-legacy  gen-sqltables
target/main.sql: target/main.yaml
	poetry run gen-sqlddl $< 1> $@ 2>> target/make.log

target/seq_datum.json: data/seq_datum.yaml target/main_generated.yaml
	poetry run linkml-convert --output $@ --target-class Ntseq --schema target/main.yaml $<

target/person_datum.json: data/person_datum.yaml target/main_generated.yaml
	poetry run linkml-convert --output $@ --target-class Person --schema target/main.yaml $<

target/SeqCollection.yaml: data/SeqCollection.tsv target/main_generated.yaml
	poetry run linkml-convert \
		--output $@ \
		--target-class SeqCollection \
		--index-slot sequences \
		--schema target/main.yaml $<

# todo
# RuntimeError: Multiple potential target classes found:
# ['Part', 'Modification', 'SeqCollection']. Please specify a target using --target_class
# or by adding tree_root: true to the relevant class in the schema.
#		--target-class SeqCollection \
#		--index-slot sequences \

#target/synbio-bestof.db: target/SeqCollection.yaml target/main_generated.yaml
#	poetry run linkml-sqldb dump \
#		--schema target/main.yaml \
#		--target-class SeqCollection \
#		--db $@ $<
#	sqlite3 $@ "select * from Ntseq" ""

# todo parameterize the output database
local/felix_dump.db: clean
	poetry run sh utils/pgsql2sqlite.sh mam 1111 parts,parts_sequences,modifications

# IF00284_adh2_202036bp_chrXIII-chrII_transposition is 202036 nt long
# the next longest sequences are ~ 49k long
target/felix_parts_seq_for_schema.tsv: local/felix_dump.db
	sqlite3 $< \
		".headers on" \
		".mode tabs" \
		'select "id" as seq_id, part_id, file, seq_name, "type" as seq_type, date_added, sequence from parts_sequences where length(sequence) < 131072;' \
		"" > $@

target/synbio-bestof.db: target/felix_parts_seq_for_schema.tsv target/main_generated.yaml
	poetry run linkml-sqldb dump \
		--schema target/main.yaml \
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
#target/class.tsv: target/main_generated.yaml
#	poetry run linkml2sheets -s target/main.yaml l2s_templates/*tsv -d target

#MAKEFLAGS += --warn-undefined-variables
#SHELL := bash
#.SHELLFLAGS := -eu -o pipefail -c
#.DEFAULT_GOAL := help
#.DELETE_ON_ERROR:
#.SUFFIXES:
#.SECONDARY:
#
#RUN = poetry run
## get values from about.yaml file
#SCHEMA_NAME = $(shell sh ./utils/get-value.sh name)
#SOURCE_SCHEMA_PATH = $(shell sh ./utils/get-value.sh source_schema_path)
#SRC = src
#DEST = project
#PYMODEL = $(SRC)/$(SCHEMA_NAME)/datamodel
#DOCDIR = docs
#
## basename of a YAML file in model/
#.PHONY: all clean
#
#help: status
#	@echo ""
#	@echo "make all -- makes site locally"
#	@echo "make install -- install dependencies"
#	@echo "make setup -- initial setup"
#	@echo "make test -- runs tests"
#	@echo "make testdoc -- builds docs and runs local test server"
#	@echo "make deploy -- deploys site"
#	@echo "make update -- updates linkml version"
#	@echo "make help -- show this help"
#	@echo ""
#
#status: check-config
#	@echo "Project: $(SCHEMA_NAME)"
#	@echo "Source: $(SOURCE_SCHEMA_PATH)"
#
#setup: install gen-project gendoc git-init-add
#
#install:
#	poetry install
#.PHONY: install
#
#all: gen-project gendoc
#%.yaml: gen-project
#deploy: all mkd-gh-deploy
#
## generates all project files
#gen-project: $(PYMODEL)
#	$(RUN) gen-project -d $(DEST) $(SOURCE_SCHEMA_PATH) && mv $(DEST)/*.py $(PYMODEL)
#
#test:
#	$(RUN) gen-project -d tmp $(SOURCE_SCHEMA_PATH)
#
#check-config:
#	@(grep my-datamodel about.yaml > /dev/null && printf "\n**Project not configured**:\n\n  - Remember to edit 'about.yaml'\n\n" || exit 0)
#
#convert-examples-to-%:
#	$(patsubst %, $(RUN) linkml-convert  % -s $(SOURCE_SCHEMA_PATH) -C Person, $(shell find src/data/examples -name "*.yaml"))
#
#examples/%.yaml: src/data/examples/%.yaml
#	$(RUN) linkml-convert -s $(SOURCE_SCHEMA_PATH) -C Person $< -o $@
#examples/%.json: src/data/examples/%.yaml
#	$(RUN) linkml-convert -s $(SOURCE_SCHEMA_PATH) -C Person $< -o $@
#examples/%.ttl: src/data/examples/%.yaml
#	$(RUN) linkml-convert -P EXAMPLE=http://example.org/ -s $(SOURCE_SCHEMA_PATH) -C Person $< -o $@
#
#upgrade:
#	poetry add -D linkml@latest
#
## Test documentation locally
#serve: mkd-serve
#
## Python datamodel
#$(PYMODEL):
#	mkdir -p $@
#
#
#$(DOCDIR):
#	mkdir -p $@
#
#gendoc: $(DOCDIR)
#	cp $(SRC)/docs/*md $(DOCDIR) ; \
#	$(RUN) gen-doc -d $(DOCDIR) $(SOURCE_SCHEMA_PATH)
#
#testdoc: gendoc serve
#
#MKDOCS = $(RUN) mkdocs
#mkd-%:
#	$(MKDOCS) $*
#
#PROJECT_FOLDERS = sqlschema shex shacl protobuf prefixmap owl jsonschema jsonld graphql excel
#git-init-add: git-init git-add git-commit git-status
#git-init:
#	git init
#git-add:
#	git add .gitignore .github Makefile LICENSE *.md examples utils about.yaml mkdocs.yml poetry.lock project.Makefile pyproject.toml src/linkml/*yaml src/*/datamodel/*py src/data
#	git add $(patsubst %, project/%, $(PROJECT_FOLDERS))
#git-commit:
#	git commit -m 'Initial commit' -a
#git-status:
#	git status
#
#clean:
#	rm -rf $(DEST)
#	rm -rf tmp
#
#include project.Makefile
