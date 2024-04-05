-- 1. Вывести названия продуктов без повторений белого или синего цвета и ценой от 10_000 до 20_000.
select DISTINCT product_sar.model, color, price from product_sar
join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
where price > 10000 and price < 20000 and (color = 'синий' or color = 'белый');









-- 2. Вывести названия компаний, поставляющие смартфоны, но не электронные книги.
select DISTINCT supplier_6xd.name from product_sar
join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
join supplier_6xd on supplier_6xd.id = supplier_product_info_1tz.supplier_id
where product_sar.category = 'смартфоны' and supplier_6xd.id not in (
    select DISTINCT supplier_6xd.id from product_sar
    join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
    join supplier_6xd on supplier_6xd.id = supplier_product_info_1tz.supplier_id
    where product_sar.category = 'электронные книги'
);













-- 3. Вывести названия компаний, поставляющие как ноутбуки, так и мониторы.
select DISTINCT supplier_6xd.name from product_sar
join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
join supplier_6xd on supplier_6xd.id = supplier_product_info_1tz.supplier_id
where product_sar.category = 'мониторы'
INTERSECT
select DISTINCT supplier_6xd.name from product_sar
join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
join supplier_6xd on supplier_6xd.id = supplier_product_info_1tz.supplier_id
where product_sar.category = 'ноутбуки';















-- 4. Вывести названия компаний поставляющие часы либо имеющие транспортные средства грузоподъемностью от 5 до 10.
select DISTINCT supplier_6xd.name from product_sar
join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
join supplier_6xd on supplier_6xd.id = supplier_product_info_1tz.supplier_id
where product_sar.category = 'часы'
UNION
select DISTINCT supplier_6xd.name from vehicle_kli
join supplier_vehicle_info_fj3 on supplier_vehicle_info_fj3.vehicle_id = vehicle_kli.id
join supplier_6xd on supplier_6xd.id = supplier_vehicle_info_fj3.supplier_id
where vehicle_kli.lifting_capacity > 5 and vehicle_kli.lifting_capacity < 10
;















-- 5. Вывести суммарную стоимость ноутбуков в бд.
SELECT sum(price) from product_sar
join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
where category = 'ноутбуки';












-- 6. Вывести модели ноутбуков (без повторений), имеющих минимальную цену в бд.
select DISTINCT model from product_sar
join supplier_product_info_1tz on product_id = product_sar.id
WHERE category = 'ноутбуки' and price = (
    select min(price) from product_sar
    join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
    where category = 'ноутбуки')
;
-- with min_price as (
--     select min(price) from product_sar
--     join supplier_product_info_1tz on supplier_product_info_1tz.product_id = product_sar.id
--     where category = 'ноутбуки'
-- ) странно, почему то не сработало













-- 7. Вывести количество различных диагоналей экранов часов в бд.
select count(screen_size) from (
    select DISTINCT screen_size from product_sar
    where category = 'часы'
) as ScrSize;
