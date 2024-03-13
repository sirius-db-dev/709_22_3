create extension if not exists "uuid-ossp";

drop table if exists clients, games, clients_to_games cascade;

create table clients 
(
	id uuid primary key default uuid_generate_v4(),
	nik_name text,
	date_reg date
);

insert into clients(nik_name, date_reg)
values
('katya', '2004-08-03'),
('nastya', '2004-09-02'),
('semyon', '2005-06-01'),
('misha', '2008-04-09');


create table games
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	cosst float,
	genre text
);

insert into games(title, cosst, genre)
values
('vartander', 157.09, 'genre1'),
('dark souls', 1000, 'horror'),
('my Tom', 200, 'like'),
('mainkraft', 300.3, 'genre2');

create table clients_to_games
(
	client_id uuid references clients,
	game_id uuid references games,
	primary key(client_id, game_id)
);

insert into clients_to_games(client_id, game_id)
values
((select id from clients where nik_name = 'katya'), (select id from games where title = 'dark souls')),
((select id from clients where nik_name = 'semyon'), (select id from games where title = 'my Tom')),
((select id from clients where nik_name = 'nastya'), (select id from games where title = 'vartander')),
((select id from clients where nik_name = 'nastya'), (select id from games where title = 'mainkraft'));

select
	clients.id,
	clients.nik_name, 
	clients.date_reg,
	coalesce (jsonb_agg(jsonb_build_object('id', g.id, 'title', g.title, 'cosst', g.cosst, 'genre', g.genre))
		filter(where g.id is not null), '[]') games
from clients
left join clients_to_games cg on clients.id = cg.client_id
left join games g on g.id = cg.game_id
group by clients.id;


select
	games.id,
	games.title, 
	games.cosst,
	games.genre,
	coalesce (jsonb_agg(jsonb_build_object('id', c.id, 'nik_name', c.nik_name, 'date_reg', c.date_reg))
		filter(where c.id is not null), '[]') clients
from games
left join clients_to_games cg on games.id = cg.game_id
left join clients c on c.id = cg.client_id
group by games.id;
















