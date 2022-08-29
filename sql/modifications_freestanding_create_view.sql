drop view if exists modifications_freestanding;

create
or replace
view modifications_freestanding as
select concat('person:', au.id)                                                                         as principal_investigator,
       p1.status,
       p1.bio_safety_level,
       p1.notes,
       concat('person:', p1.creator_id)                                                                 as creator,
       REPLACE(m.element_id, 'IF', 'IF:')                                                               as "id",
       m."element"                                                                                      as el_name_long,
       m.element_name                                                                                   as el_name_short,
       m."descriptor",
       cast(REPLACE(m."size", 'bp', '') as int)                                                         as "size_bp",
       m."position",
       m.aa_change,
       m.modification_type,
       m.category,
       m.subcategory_size,
       CASE
           WHEN m.taxon_id IS NULL
               THEN NULL
           ELSE concat('NCBITaxon:', m.taxon_id) END                                                    as element_organism,
       CASE
           WHEN m.modifications_genes_id IS NULL
               THEN NULL
           ELSE concat('gene:', m.modifications_genes_id) END                                           as modifications_genes,
       array_to_string(array_agg(distinct replace(replace( p2.alias, 'IF', 'IF:'), 'MS_', 'MS:')), '|') as parent_parts
from parts p1
         join modifications m
              on
                  p1.id = m.parts_ptr_id
         join auth_user au on
    p1.principal_investigator = concat(au.first_name, ' ', au.last_name)
         join sub_parts sp1 on
    sp1.sub_part_id = p1.id
         join parts p2 on p2.id = sp1.parent_part_id
where category != 'NA'
group by au.id, p1.status, p1.bio_safety_level, p1.notes, p1.creator_id, m.element_id, m."element", m.element_name, m."descriptor",
    m."size", m."position", m.aa_change, m.modification_type, m.category, m.subcategory_size, m.element_id_number,
    m.modifications_genes_id, m.taxon_id;
