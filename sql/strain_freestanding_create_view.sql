drop view if exists strain_freestanding;

create
or replace
view strain_freestanding as
select p."name",
       REGEXP_REPLACE(p."genotype_phenotype", '\s+', ' ', 'g')                                          as "genotype_phenotype",
       REGEXP_REPLACE(p."intellectual_property", '\s+', ' ', 'g')                                       as "intellectual_property",
       REGEXP_REPLACE(p."keywords", '\s+', ' ', 'g')                                                    as "keywords",
       REGEXP_REPLACE(p."notes", '\s+', ' ', 'g')                                                       as "notes",
       REGEXP_REPLACE(p."references", '\s+', ' ', 'g')                                                  as "references",
       REGEXP_REPLACE(p."summary", '\s+', ' ', 'g')                                                     as "summary",
       p.bio_safety_level,
       concat('person:', au.id)                                                                         as principal_investigator,
       concat('person:', p.creator_id)                                                                  as creator,
       concat('species:', p.host_species_id)                                                            as host_organism,
       p.funding_source,
       replace(p.alias, '_', ':')                                                                       as id,
       p.status,
       array_to_string(array_agg(distinct replace(replace( p2.alias, 'IF', 'IF:'), 'MS_', 'MS:')), '|') as sub_parts,
       array_to_string(array_agg(distinct replace(replace( p3.alias, 'IF', 'IF:'), 'MS_', 'MS:')), '|') as parent_parts
from parts p
         join auth_user au on
    p.principal_investigator = concat(au.first_name, ' ', au.last_name)
         join sub_parts sp1 on
    sp1.parent_part_id = p.id
         join parts p2 on p2.id = sp1.sub_part_id
         join sub_parts sp2 on
    sp2.parent_part_id = p.id
         join parts p3 on p3.id = sp2.parent_part_id
where p."type" = 'STRAIN'
  and p.alias ~ 'MS_\d+'
group by
    p."name",
    p."references",
    au.id,
    p.bio_safety_level,
    p.creator_id,
    p.funding_source,
    p.genotype_phenotype,
    host_organism,
    p.intellectual_property,
    p.keywords,
    p.notes,
    p.alias,
    p.principal_investigator,
    p.status,
    p.summary;