create extension if not exists "uuid-ossp";

create table games
(
    id      uuid primary key default uuid_generate_v4(),
    title   text,
    genre   text,
    price   float
);

create table buyers
(
    id              uuid primary key default uuid_generate_v4(),
    username        text,
    registration    date
);

create table game_to_buyer
(
    game_id uuid references games,
    buyer_id uuid references buyers,
    primary key (game_id, buyer_id)
);

insert into games(title, genre, price) values
('Forza', 'Гонки', 1200.5),
('Minecraft', 'Приключения', 500.99),
('Fortnite', 'Шутер', 1000),
('CS2', 'Шутер', 200);

insert into buyers(username, registration) values
('Kaat', '2023-02-20'),
('unknown', '2014-08-20'),
('niqzart', '2020-06-15'),
('poetry', '2024-01-09');

insert into game_to_buyer(game_id, buyer_id) values
((select id from games where title = 'Forza'),
 (select id from buyers where username = 'Kaat')),
((select id from games where title = 'Forza'),
 (select id from buyers where username = 'unknown')),
((select id from games where title = 'Forza'),
 (select id from buyers where username = 'niqzart')),
((select id from games where title = 'Minecraft'),
 (select id from buyers where username = 'poetry')),
((select id from games where title = 'Minecraft'),
 (select id from buyers where username = 'unknown')),
((select id from games where title = 'Fortnite'),
 (select id from buyers where username = 'Kaat')),
((select id from games where title = 'Fortnite'),
 (select id from buyers where username = 'poetry'));
 
select
    b.id,
    b.username,
    b.registration,
    coalesce(jsonb_agg(jsonb_build_object(
    'id', g.id, 'title', g.title, 'genre', g.genre))
      filter (where g.id is not null), '[]') as games
from buyers b
left join game_to_buyer gtb on b.id = gtb.buyer_id
left join games g on g.id = gtb.game_id
group by b.id;

select
    g.id,
    g.title,
    g.genre,
    g.price,
    coalesce(jsonb_agg(jsonb_build_object(
    'id', b.id, 'username', b.username, 'registration', b.registration))
      filter (where b.id is not null), '[]') as byers
from games g
left join game_to_buyer gtb on g.id = gtb.game_id
left join buyers b on b.id = gtb.buyer_id
group by g.id;