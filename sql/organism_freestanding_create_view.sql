drop view if exists organism_freestanding;

create
or replace view organism_freestanding as
select concat('organism:', id) as id,
       species                 as abbreviation,
       strain                  as strain_value,
       "comment",
--        default_genome_id,
       "name"                  as species_name
from species s
union
(select distinct concat('NCBITaxon:', taxon_id) as id,
                 NULL                           as abbreviation,
                 NULL                           as strain_value,
                 NULL                           as "comment",
                 element_species                as "name"
 from modifications m
 where taxon_id is not null
   and taxon_id != '' and taxon_id != '6100')