.headers on
.mode tabs

select distinct
	"aa_change",
	"alias" as mod_alias,
	"bio_safety_level",
	"category",
	"creator_id",
	"descriptor",
	"element",
	"element_id",
	"element_id_number",
	"element_name",
	"element_species",
--	"funding_source",
--	"genotype_phenotype",
--	"host_species_id",
	"id" as modification_id,
--	"intellectual_property",
--	"keywords",
	"modification_type",
	"name",
	"notes",
	"position",
	"principal_investigator",
	"principal_investigator_email" as email,
--	"references",
	"size",
	"status",
	"subcategory_size",
--	"summary",
	"taxon_id",
	"type"
from
	modifications m
left join parts p on
	m.parts_ptr_id = p.id
where id != 2557 ;
