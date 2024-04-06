--№1 Вывести названия продуктов без повторений белого или синего цвета и ценой от 10_000 до 20_000.
select distinct model
from product_bxy p
join supplier_product_info_bnv sp on sp.product_id = p.id
where (p.color = 'белый' or p.color = 'синий') and sp.price >= 10000 and sp.price <= 20000;

--№2  Вывести названия компаний, поставляющие смартфоны, но не электронные книги.
select distinct s.name
from supplier_wo2 s
join supplier_product_info_bnv sp on sp.supplier_id = s.id
join product_bxy p on sp.product_id = p.id
where p.category = 'смартфоны'
except
select distinct s.name
from supplier_wo2 s
join supplier_product_info_bnv sp on sp.supplier_id = s.id
join product_bxy p on sp.product_id = p.id
where p.category = 'электронные книги';

--№3 Вывести названия компаний, поставляющие как ноутбуки, так и мониторы.
select distinct s.name
from supplier_wo2 s
join supplier_product_info_bnv sp on sp.supplier_id = s.id
join product_bxy p on sp.product_id = p.id
where p.category = 'ноутбуки'
intersect
select distinct s.name
from supplier_wo2 s
join supplier_product_info_bnv sp on sp.supplier_id = s.id
join product_bxy p on sp.product_id = p.id
where p.category = 'мониторы';

--№4 Вывести названия компаний поставляющие часы либо имеющие транспортные средства грузоподъемностью от 5 до 10.
select distinct s.name
from supplier_wo2 s
join supplier_product_info_bnv sp on sp.supplier_id = s.id
join product_bxy p on sp.product_id = p.id
where p.category = 'часы'
union
select distinct s.name
from supplier_wo2 s
join supplier_vehicle_info_o7n sv on sv.supplier_id = s.id
join vehicle_u2i v on sv.vehicle_id = v.id
where v.lifting_capacity >= 5 and v.lifting_capacity <= 10;

--№5 Вывести суммарную стоимость ноутбуков в бд.
select sum(price*quantity)
from product_bxy p
join supplier_product_info_bnv sp on sp.product_id = p.id
join supplier_wo2 s on sp.supplier_id = s.id;

--№6 Вывести модели ноутбуков (без повторений), имеющих минимальную цену в бд.
select distinct p.model
from product_bxy p
join supplier_product_info_bnv sp on sp.product_id = p.id
where sp.price = (select min(sp.price)
from product_bxy p
join supplier_product_info_bnv sp on sp.product_id = p.id
where p.category = 'ноутбуки') and p.category = 'ноутбуки';

--№7 Вывести количество различных диагоналей экранов часов в бд.
select count(distinct screen_size)
from product_bxy
where category = 'часы';
