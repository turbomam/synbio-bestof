-- public.person_freestanding source

drop view if exists person_freestanding;

create
or replace
view public.person_freestanding
as
select concat('person:', id)                         as "id",
       username,
       email,
       first_name,
       last_name,
       cast(is_staff as text)                        as "is_staff",
       cast(is_superuser as text)                    as "is_superuser",
       to_char(date_joined, 'YYYY-MM-DD-HH24:MI:SS') as "date_joined"
from auth_user au;
