drop view if exists sequences_freestanding;

create
or replace
view sequences_freestanding as
select concat('sequence:', ps.id)                   as id,
       replace(p.alias, 'IF', 'IF:')                as "associated_part",
       seq_name,
       ps."type"                                    as seq_type,
       to_char(date_added, 'YYYY-MM-DD-HH24:MI:SS') as "date_added",
       "sequence"                                   as nt_sequence
from parts_sequences ps
         join parts p on
    ps.part_id = p.id
where char_length(sequence) < 131071;
