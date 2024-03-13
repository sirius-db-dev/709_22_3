create extension if not exists "uuid-ossp";

drop table if exists providers, shops, provider_to_shop cascade;


create table providers
(
	id uuid primary key default uuid_generate_v4(),
	p_name text,
	phone_num text
);


insert into providers(p_name, phone_num) values
('Andrew', '+79864567235'),
('Leon', '+73457435672'),
('Maksim', '+45678263498'),
('Sergey', '+53293257592');



create table shops
(
	id uuid primary key default uuid_generate_v4(),
	s_name text,
	address text
);


insert into shops(s_name, address) values
('CM', 'Sochi, Sirius, 12'),
('Mounty', 'Sochi, Moscowsckaya, 5'),
('Letout', 'Moscow, Lenina, 146/3'),
('Decent', 'Arzamas, Sovetsckaya, 54');

create table provider_to_shop
(
    provider_id uuid references providers,
    shop_id  uuid references shops,
    primary key (provider_id, shop_id)
);


insert into provider_to_shop(provider_id, shop_id)
values
    ((select id from providers where phone_num = '+79864567235'),
     (select id from shops where s_name = 'CM')),
    ((select id from providers where phone_num = '+79864567235'),
     (select id from shops where s_name = 'Mounty')),
    ((select id from providers where phone_num = '+79864567235'),
     (select id from shops where s_name = 'Decent')),
    ((select id from providers where phone_num = '+45678263498'),
     (select id from shops where s_name = 'CM')),
    ((select id from providers where phone_num = '+45678263498'),
     (select id from shops where s_name = 'Mounty')),
    ((select id from providers where phone_num = '+53293257592'),
     (select id from shops where s_name = 'CM'));
	

--1
select
  p.id,
  p.p_name,
  p.phone_num,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', s.id, 'name', s.s_name, 'address', s.address))
      filter (where s.id is not null), '[]') as shops
from providers p
left join provider_to_shop ps on p.id = ps.provider_id
left join shops s on s.id = ps.shop_id
group by p.id;


--2
select
  s.id,
  s.s_name,
  s.address,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', p.id, 'name', p.p_name, 'phone number', p.phone_num))
      filter (where p.id is not null), '[]') as providers
from shops s
left join provider_to_shop ps on s.id = ps.shop_id
left join providers p on p.id = ps.provider_id
group by s.id;
