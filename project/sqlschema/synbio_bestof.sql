

CREATE TABLE "ModCollection" (
	modifications TEXT, 
	PRIMARY KEY (modifications)
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
	PRIMARY KEY (modification_id)
);

CREATE TABLE "Ntseq" (
	seq_id TEXT NOT NULL, 
	part_id TEXT NOT NULL, 
	file TEXT NOT NULL, 
	seq_name TEXT NOT NULL, 
	seq_type TEXT NOT NULL, 
	date_added TEXT NOT NULL, 
	sequence TEXT NOT NULL, 
	PRIMARY KEY (seq_id)
);

CREATE TABLE "OmniCollection" (
	sequences TEXT, 
	modifications TEXT, 
	PRIMARY KEY (sequences, modifications)
);

CREATE TABLE "Organism" (
	organism_id TEXT, 
	"NCBI_id" TEXT, 
	details TEXT, 
	PRIMARY KEY (organism_id, "NCBI_id", details)
);

CREATE TABLE "Person" (
	person_id TEXT NOT NULL, 
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
	sequences TEXT, 
	PRIMARY KEY (sequences)
);
