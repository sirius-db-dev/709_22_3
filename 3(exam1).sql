--Поставщики и транспортные средства:
--
--    поставщик может иметь несколько транспортных средств
--    транспортное средство может принадлежать только одному поставщику
--    поставщик - название, телефон
--    транспортное средство - марка, модель, грузоподъемность


create table provider
(
	id int primary key,
	title text,
	phone text
);


create table vehicles
(
	id int primary key,
	provider_id int references provider,
	brand text,
	model text,
	weight int
);


insert into provider (id, title, phone) values
(1, 'Почта России', '88005553535'),
(2, 'Голубинная поча', '89282037102'),
(3, 'СДЭК', '7973749373'),
(4, 'Rasberry','889898989');


insert into vehicles(id, provider_id, brand, model, weight) values
(1, 4, 'ГАЗ', '2101', 100),
(2, 4, 'ВАЗ', '4001', 211),
(3, 1, 'Foo', 'Bar', 50);



select
	p.id,
	p.title,
	p.phone,
	coalesce(jsonb_agg(json_build_object(
	'id', v.id, 'brand', v.brand, 'model', v.model, 'weight', v.weight))
	filter (where v.id is not null), '[]')
from provider p
left join vehicles v on p.id = v.provider_id
group by p.id;



