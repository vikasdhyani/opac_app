create or replace view memberships as
select * from dev_memberships
with read only;
