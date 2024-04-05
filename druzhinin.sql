-- 1
select distinct model from product_gnc prod
join supplier_product_info_u9n spiun on spiun.product_id = prod.id
where color = 'белый' or color = 'синий'
and price >= 10000 and price <= 20000

-- 2
select name from supplier_hn4 sup
join supplier_product_info_u9n spiun on spiun.supplier_id = sup.id
join product_gnc prod on spiun.product_id = prod.id
where category = 'смартфоны'

except

select name from supplier_hn4 sup
join supplier_product_info_u9n spiun on spiun.supplier_id = sup.id
join product_gnc prod on spiun.product_id = prod.id
where category = 'электронные книги'

-- 3
select name from supplier_hn4 sup
join supplier_product_info_u9n spiun on spiun.supplier_id = sup.id
join product_gnc prod on spiun.product_id = prod.id
where category = 'ноутбуки'

intersect

select name from supplier_hn4 sup
join supplier_product_info_u9n spiun on spiun.supplier_id = sup.id
join product_gnc prod on spiun.product_id = prod.id
where category = 'мониторы'

-- 4
select name from supplier_hn4 sup
join supplier_product_info_u9n spiun on spiun.supplier_id = sup.id
join product_gnc prod on spiun.product_id = prod.id
where category = 'часы'

union

select name from supplier_hn4 sup
join supplier_vehicle_info_ota svio on svio.supplier_id = sup.id 
join vehicle_kp6 veh on svio.vehicle_id = veh.id 
where lifting_capacity >= 5 and lifting_capacity <= 10

-- 5
select sum(price) from product_gnc prod
join supplier_product_info_u9n spiun on spiun.product_id = prod.id
where category = 'ноутбуки'

-- 6
select distinct model from product_gnc prod
join supplier_product_info_u9n spiun on spiun.product_id = prod.id
where price = (
    select min(price) from product_gnc prod
    join supplier_product_info_u9n spiun on spiun.product_id = prod.id
    where category = 'ноутбуки'
)
and category = 'ноутбуки'

-- 7
select count(distinct screen_size) from product_gnc prod
where category = 'часы'
