create extension if not exists "uuid-ossp";

create table providers
(
    id      uuid primary key default uuid_generate_v4(),
    title   text,
    phone   text
);

create table markets
(
    id      uuid primary key default uuid_generate_v4(),
    title   text,
    address text
);

create table providers_to_markets
(
    provider_id uuid references providers,
    market_id uuid references markets,
    primary key (provider_id, market_id)
);

insert into providers(title, phone) values
('Поставщик1', '+79542347832'),
('Поставщик2', '+72545347852'),
('Поставщик3', '+79543347432'),
('Поставщик4', '+72546347332');

insert into markets(title, address) values
('Магнит', 'Воскресенская 12'),
('Пятерочка', 'Анархии 3'),
('КБ', 'Восстания 55'),
('Яблоко', 'Ленина 32');

insert into providers_to_markets(provider_id, market_id) values
((select id from providers where title = 'Поставщик1'),
 (select id from markets where title = 'Магнит')),
((select id from providers where title = 'Поставщик1'),
 (select id from markets where title = 'Пятерочка')),
((select id from providers where title = 'Поставщик1'),
 (select id from markets where title = 'КБ')),
((select id from providers where title = 'Поставщик2'),
 (select id from markets where title = 'Магнит')),
((select id from providers where title = 'Поставщик2'),
 (select id from markets where title = 'Пятерочка')),
((select id from providers where title = 'Поставщик3'),
 (select id from markets where title = 'Магнит')),
((select id from providers where title = 'Поставщик3'),
 (select id from markets where title = 'Пятерочка')),
((select id from providers where title = 'Поставщик3'),
 (select id from markets where title = 'КБ'));

select
    p.id,
    p.title,
    p.phone,
    coalesce(jsonb_agg(jsonb_build_object(
    'id', m.id, 'title', m.title, 'address', m.address))
      filter (where m.id is not null), '[]') as markets
from providers p
left join providers_to_markets ptm on p.id = ptm.provider_id
left join markets m on m.id = ptm.market_id
group by p.id;

select
    m.id,
    m.title,
    m.address,
    coalesce(jsonb_agg(jsonb_build_object(
    'id', p.id, 'title', p.title, 'phone', p.phone))
      filter (where p.id is not null), '[]') as providers
from markets m
left join providers_to_markets ptm on m.id = ptm.market_id
left join providers p on p.id = ptm.provider_id
group by m.id;