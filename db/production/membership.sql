create or replace view memberships as
select
  a.userplanid id,
  a.membercardno card_id,
  a.memberid member_id,
  d.firstname || ' ' || d.middlename || ' ' || d.lastname member,
  d.city,
  a.planid plan_id,
  b.description plan,
  NVL(c.cardstatus, 0) inactive,
  d.address1||' '||d.address2||' '||d.address3 address,
  d.lphone lphone,
  d.mphone mphone
from jbprod.userplan a, jbprod.plan b, jbprod.usercardhistory c, jbprod.useradmin d
where a.planid = b.planid (+)
  and a.membercardno = c.membercardno (+)
  and a.memberid = d.memberid (+)
with read only
;
