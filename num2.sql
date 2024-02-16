drop table if exists provider, transport cascade;

create table provider
(
	id int primary key,
	title text,
	phone text
);

insert into provider(id, title, phone)
values
(1, 'provider1', '89195138805'),
(2, 'provider2', '89195193928'),
(3, 'provider3', '89127317908'),
(4, 'provider4', '89195396745');

create table transport
(
	id int primary key,
	model text,
	volume text,
	number int,
	provider_id int references provider
);

insert into transport(id, model, volume, number, provider_id)
values
(1, 'грузовик', '800', 234, 2),
(2, 'легковушка', '900', 178, 1),
(3, 'седан', '700', 365, 3);

select
	provider.id,
	provider.title, 
	provider.phone,
	coalesce (jsonb_agg(jsonb_build_object('id', t.id, 'model', t.model, 'volume',
		t.volume, 'number', t.number, 'provider_id', t.provider_id))
		filter(where t.id is not null), '[]') transport
from provider
left join transport t on provider.id = t.provider_id
group by provider.id;








