drop table if exists festivals, performances cascade;

create table festivals
(
	id int primary key
		generated by default as identity,
	name text,
	f_date_start date,
	f_date_end date,
	place text
);

insert into festivals(name, f_date_start, f_date_end, place) values
('VK_FEST', '2023-7-8', '2023-8-30', 'Sirirus'),
('Palaces of St. Petersburg', '2024-1-22', '2024-12-31',  'Saint-Petersburg');

create table performances
(
	id int primary key
		generated by default as identity,
	festival_id int references games,
	name text,
	p_date date,
	genre text
);

insert into performances(festival_id, name, p_date, genre) values
(2, 'Love letters', '2024-2-14', 'musical and poetic evening'),
(1, 'Klava Koka Concert', '2023-7-8', 'music'),
(1, 'Leonid Agutin performance', '2024-7-16', 'conversation');

select
	f.id,
	f.name,
	f.f_date_start,
	f.f_date_end,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', p.id, 'festival_id', p.festival_id, 'name', p.name, 'performance_date', p.p_date, 'genre', p.genre))
	filter (where p.id is not null), '[]') as performance
from festivals f
left join performances p on p.festival_id = f.id
group by f.id;
