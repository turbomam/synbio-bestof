

CREATE TABLE "Database" (
	strain_set TEXT, 
	modification_set TEXT, 
	organism_set TEXT, 
	person_set TEXT, 
	sequence_set TEXT, 
	PRIMARY KEY (strain_set, modification_set, organism_set, person_set, sequence_set)
);

CREATE TABLE "NamedThing" (
	id TEXT NOT NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE "Organism" (
	abbreviation TEXT, 
	strain_value TEXT, 
	comment TEXT, 
	species_name TEXT, 
	taxid TEXT, 
	id TEXT NOT NULL, 
	special_name TEXT, 
	species_ncbi_taxon_number TEXT, 
	PRIMARY KEY (id)
);

CREATE TABLE "Person" (
	id TEXT NOT NULL, 
	date_joined DATETIME NOT NULL, 
	email TEXT, 
	first_name TEXT, 
	is_staff BOOLEAN NOT NULL, 
	is_superuser BOOLEAN NOT NULL, 
	last_name TEXT, 
	username TEXT NOT NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE "Modification" (
	aa_change TEXT, 
	bio_safety_level VARCHAR(7) NOT NULL, 
	category VARCHAR(21), 
	creator TEXT NOT NULL, 
	descriptor VARCHAR(22), 
	el_name_long TEXT NOT NULL, 
	el_name_short TEXT, 
	element_organism TEXT, 
	modification_type VARCHAR(26), 
	modifications_genes TEXT, 
	notes TEXT, 
	position TEXT, 
	principal_investigator TEXT NOT NULL, 
	size_bp INTEGER, 
	status VARCHAR(11) NOT NULL, 
	subcategory_size TEXT, 
	id TEXT NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(creator) REFERENCES "Person" (id), 
	FOREIGN KEY(principal_investigator) REFERENCES "Person" (id)
);

CREATE TABLE "Strain" (
	id TEXT NOT NULL, 
	bio_safety_level VARCHAR(7), 
	creator TEXT, 
	funding_source VARCHAR(11), 
	genotype_phenotype TEXT, 
	host_organism TEXT, 
	intellectual_property TEXT, 
	keywords TEXT, 
	name TEXT, 
	notes TEXT, 
	principal_investigator TEXT, 
	"references" TEXT, 
	status VARCHAR(11), 
	summary TEXT, 
	PRIMARY KEY (id), 
	FOREIGN KEY(creator) REFERENCES "Person" (id), 
	FOREIGN KEY(host_organism) REFERENCES "Organism" (id), 
	FOREIGN KEY(principal_investigator) REFERENCES "Person" (id)
);

CREATE TABLE "PartsSequence" (
	id TEXT NOT NULL, 
	associated_part TEXT, 
	seq_name TEXT, 
	seq_type VARCHAR(9), 
	date_added TEXT, 
	nt_sequence TEXT, 
	PRIMARY KEY (id), 
	FOREIGN KEY(associated_part) REFERENCES "Modification" (id)
);

CREATE TABLE "Modification_parent_parts" (
	backref_id TEXT, 
	parent_parts TEXT, 
	PRIMARY KEY (backref_id, parent_parts), 
	FOREIGN KEY(backref_id) REFERENCES "Modification" (id)
);

CREATE TABLE "Strain_sub_parts" (
	backref_id TEXT, 
	sub_parts TEXT, 
	PRIMARY KEY (backref_id, sub_parts), 
	FOREIGN KEY(backref_id) REFERENCES "Strain" (id)
);

CREATE TABLE "Strain_parent_parts" (
	backref_id TEXT, 
	parent_parts TEXT, 
	PRIMARY KEY (backref_id, parent_parts), 
	FOREIGN KEY(backref_id) REFERENCES "Strain" (id)
);
