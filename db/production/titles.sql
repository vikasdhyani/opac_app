create or replace view titles as
select
    titleid id,
    title title,
    authorid author_id,
    nvl(publisherid,50) publisher_id,
    yearofpublication yearofpublication,
    edition edition,
    category category_id,
    isbn_10 isbn10,
    isbn_13 isbn13,
    no_of_pages noofpages,
    language language,
    nooftimesrated cnt_rated,
    bookrating rating,
    no_of_rented,
    titletype title_type,
    format,
    length,
    isbn_13 isbn
from jbprod.titles
with read only
;
