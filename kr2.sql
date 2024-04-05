-- 1

select distinct p.model
from product_n3i p
join vendor_product_info_bzs v on v.product_id = p.id
where (p.color = 'белый' or p.color = 'синий') and (v.price > 10000 and v.price < 20000);


-- 2


select distinct brand
from product_n3i p
where category = 'смартфоны' and brand not in (select brand
                                                  from product_n3i p
                                                  where p.category = 'электронные книги');

-- 3

select brand
from product_n3i
where category = 'ноутбуки'
intersect
select brand
from product_n3i
where category = 'мониторы' ;


-- 4

select distinct vendor_vld.name
from vendor_transport_info_6zx
join vendor_vld on vendor_vld.id = vendor_transport_info_6zx.vendor_id
join transport_23q on vendor_transport_info_6zx.transport_id = transport_23q.id
join vendor_product_info_bzs on vendor_vld.id = vendor_product_info_bzs.vendor_id
join product_n3i on product_n3i.id = vendor_product_info_bzs.product_id
where product_n3i.category = 'часы' or (transport_23q.lifting_capacity > 5 and transport_23q.lifting_capacity < 10);

-- 5

select sum(price)
from product_n3i
join vendor_product_info_bzs on product_n3i.id = vendor_product_info_bzs.product_id
where category = 'ноутбуки';

-- 6

select  distinct model
from product_n3i
join vendor_product_info_bzs on product_n3i.id = vendor_product_info_bzs.product_id
where price = (
select min(price)
from product_n3i
join vendor_product_info_bzs on product_n3i.id = vendor_product_info_bzs.product_id);

-- 7

select  count(distinct screen_size)
from product_n3i
where category = 'часы';

