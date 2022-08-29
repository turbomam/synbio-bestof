-- # Class: "Organism" Description: ""
--     * Slot: id Description: 
--     * Slot: organism_id Description: 
--     * Slot: NCBI_id Description: 
--     * Slot: details Description: 
-- # Class: "Part" Description: ""
--     * Slot: id Description: 
--     * Slot: alias Description: 
--     * Slot: bio_safety_level Description: 
--     * Slot: creator Description: 
--     * Slot: funding_source Description: 
--     * Slot: genotype_phenotype Description: 
--     * Slot: intellectual_property Description: 
--     * Slot: keywords Description: 
--     * Slot: notes Description: 
--     * Slot: part_id Description: 
--     * Slot: part_name Description: 
--     * Slot: part_type Description: 
--     * Slot: principal_investigator Description: 
--     * Slot: references Description: 
--     * Slot: status Description: 
--     * Slot: summary Description: 
-- # Class: "Person" Description: ""
--     * Slot: person_id Description: 
--     * Slot: person_name Description: 
--     * Slot: first_name Description: 
--     * Slot: last_name Description: 
--     * Slot: last_login Description: 
--     * Slot: is_superuser Description: 
--     * Slot: username Description: 
--     * Slot: email Description: 
--     * Slot: is_staff Description: 
--     * Slot: is_active Description: 
--     * Slot: date_joined Description: 
-- # Class: "Ntseq" Description: ""
--     * Slot: seq_id Description: 
--     * Slot: part_id Description: 
--     * Slot: file Description: 
--     * Slot: seq_name Description: 
--     * Slot: seq_type Description: 
--     * Slot: date_added Description: 
--     * Slot: sequence Description: 
--     * Slot: SeqCollection_id Description: Autocreated FK slot
--     * Slot: OmniCollection_id Description: Autocreated FK slot
-- # Class: "SeqCollection" Description: ""
--     * Slot: id Description: 
-- # Class: "Modification" Description: ""
--     * Slot: aa_change Description: 
--     * Slot: bio_safety_level Description: 
--     * Slot: category Description: 
--     * Slot: creator_id Description: 
--     * Slot: descriptor Description: 
--     * Slot: element Description: 
--     * Slot: element_id Description: 
--     * Slot: element_id_number Description: 
--     * Slot: element_name Description: 
--     * Slot: element_species Description: 
--     * Slot: email Description: 
--     * Slot: mod_alias Description: 
--     * Slot: modification_id Description: 
--     * Slot: modification_type Description: 
--     * Slot: name Description: 
--     * Slot: notes Description: 
--     * Slot: position Description: 
--     * Slot: principal_investigator Description: 
--     * Slot: SC_curated_enzyme_name Description: 
--     * Slot: SC_curated_gene_name Description: 
--     * Slot: SC_curated_protein_name Description: 
--     * Slot: SC_curated_uniprot_id Description: 
--     * Slot: seq2ids_alias Description: 
--     * Slot: seq2ids_all_go Description: 
--     * Slot: seq2ids_bitscore Description: 
--     * Slot: seq2ids_blast_db Description: 
--     * Slot: seq2ids_gene_name_1ry Description: 
--     * Slot: seq2ids_gene_names Description: 
--     * Slot: seq2ids_organism Description: 
--     * Slot: seq2ids_prot_function Description: 
--     * Slot: seq2ids_prot_names Description: 
--     * Slot: seq2ids_sacc Description: 
--     * Slot: size Description: 
--     * Slot: status Description: 
--     * Slot: subcategory_size Description: 
--     * Slot: taxon_id Description: 
--     * Slot: type Description: 
--     * Slot: ModCollection_id Description: Autocreated FK slot
--     * Slot: OmniCollection_id Description: Autocreated FK slot
-- # Class: "ModCollection" Description: ""
--     * Slot: id Description: 
-- # Class: "OmniCollection" Description: ""
--     * Slot: id Description: 

CREATE TABLE "Organism" (
	id INTEGER, 
	organism_id TEXT, 
	"NCBI_id" TEXT, 
	details TEXT, 
	PRIMARY KEY (id)
);
CREATE TABLE "Person" (
	person_id TEXT, 
	person_name TEXT, 
	first_name TEXT NOT NULL, 
	last_name TEXT, 
	last_login DATETIME, 
	is_superuser BOOLEAN, 
	username TEXT, 
	email TEXT, 
	is_staff BOOLEAN, 
	is_active BOOLEAN, 
	date_joined DATETIME, 
	PRIMARY KEY (person_id)
);
CREATE TABLE "SeqCollection" (
	id INTEGER, 
	PRIMARY KEY (id)
);
CREATE TABLE "ModCollection" (
	id INTEGER, 
	PRIMARY KEY (id)
);
CREATE TABLE "OmniCollection" (
	id INTEGER, 
	PRIMARY KEY (id)
);
CREATE TABLE "Part" (
	id INTEGER, 
	alias TEXT, 
	bio_safety_level TEXT NOT NULL, 
	creator TEXT, 
	funding_source TEXT, 
	genotype_phenotype TEXT, 
	intellectual_property TEXT, 
	keywords TEXT, 
	notes TEXT, 
	part_id TEXT NOT NULL, 
	part_name TEXT NOT NULL, 
	part_type TEXT NOT NULL, 
	principal_investigator TEXT NOT NULL, 
	"references" TEXT, 
	status TEXT NOT NULL, 
	summary TEXT NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(creator) REFERENCES "Person" (person_id)
);
CREATE TABLE "Ntseq" (
	seq_id TEXT NOT NULL, 
	part_id TEXT NOT NULL, 
	file TEXT NOT NULL, 
	seq_name TEXT NOT NULL, 
	seq_type TEXT NOT NULL, 
	date_added TEXT NOT NULL, 
	sequence TEXT NOT NULL, 
	"SeqCollection_id" TEXT, 
	"OmniCollection_id" TEXT, 
	PRIMARY KEY (seq_id), 
	FOREIGN KEY("SeqCollection_id") REFERENCES "SeqCollection" (id), 
	FOREIGN KEY("OmniCollection_id") REFERENCES "OmniCollection" (id)
);
CREATE TABLE "Modification" (
	aa_change TEXT, 
	bio_safety_level TEXT NOT NULL, 
	category TEXT, 
	creator_id TEXT NOT NULL, 
	descriptor TEXT, 
	element TEXT NOT NULL, 
	element_id TEXT NOT NULL, 
	element_id_number TEXT NOT NULL, 
	element_name TEXT, 
	element_species TEXT, 
	email TEXT, 
	mod_alias TEXT NOT NULL, 
	modification_id TEXT NOT NULL, 
	modification_type TEXT, 
	name TEXT NOT NULL, 
	notes TEXT, 
	position TEXT, 
	principal_investigator TEXT NOT NULL, 
	"SC_curated_enzyme_name" TEXT, 
	"SC_curated_gene_name" TEXT, 
	"SC_curated_protein_name" TEXT, 
	"SC_curated_uniprot_id" TEXT, 
	seq2ids_alias TEXT, 
	seq2ids_all_go TEXT, 
	seq2ids_bitscore TEXT, 
	seq2ids_blast_db TEXT, 
	seq2ids_gene_name_1ry TEXT, 
	seq2ids_gene_names TEXT, 
	seq2ids_organism TEXT, 
	seq2ids_prot_function TEXT, 
	seq2ids_prot_names TEXT, 
	seq2ids_sacc TEXT, 
	size TEXT, 
	status TEXT NOT NULL, 
	subcategory_size TEXT, 
	taxon_id TEXT, 
	type TEXT NOT NULL, 
	"ModCollection_id" TEXT, 
	"OmniCollection_id" TEXT, 
	PRIMARY KEY (modification_id), 
	FOREIGN KEY("ModCollection_id") REFERENCES "ModCollection" (id), 
	FOREIGN KEY("OmniCollection_id") REFERENCES "OmniCollection" (id)
);
