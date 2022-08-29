drop view if exists organism_freestanding;

create
or replace view organism_freestanding as
select concat('organism:', id) as id,
       species                 as abbreviation,
       strain                  as strain_value,
       "comment",
--        default_genome_id,
       "name"                  as species_name
from species s;