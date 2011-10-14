create or replace view memberships as
select * from dev_memberships
with read only;

create or replace view titles as
select * from dev_titles
with read only;
