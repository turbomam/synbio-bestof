drop view if exists modifications_freestanding;

create
or replace
view modifications_freestanding as
select concat('person:', au.id)                as principal_investigator,
       status,
       bio_safety_level,
       notes,
       concat('person:', creator_id)           as creator,
       REPLACE(element_id, 'IF', 'IF:')        as "id",
       "element"                               as el_name_long,
       element_name                            as el_name_short,
       "descriptor",
       cast(REPLACE("size", 'bp', '') as int)  as "size_bp",
       "position",
       aa_change,
       modification_type,
       category,
       subcategory_size,
       concat('NCBITaxon:', element_id_number) as element_organism,
       concat('gene:', modifications_genes_id) as modifications_genes
from parts p
         join modifications m on
    p.id = m.parts_ptr_id
         join auth_user au on
    p.principal_investigator = concat(au.first_name, ' ', au.last_name)
where category != 'NA';