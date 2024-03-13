create extension if not exists "uuid-ossp";

drop table if exists musicants, music, musicants_to_music cascade;


create table musicants
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	date_born date
);

insert into musicants(first_name, last_name, date_born)
values
('katya', 'prohochyova', '2004-08-03'),
('nastya', 'zemlyanova', '2004-09-02'),
('semyon', 'komarov', '2005-06-01'),
('misha', 'lebedev', '2008-04-09');


create table music
(
	id uuid primary key default uuid_generate_v4(),
	title text, 
	genre text,
	duration float
);

insert into music(title, genre, duration)
values 
('танец феи драже', 'genre1', 3.01),
('лунная соната', 'genre2', 6.43),
('токката и фуга ре минор', 'genre3', 7.53),
('танец принца оршада и феи драже', 'genre4', 4.59);


create table musicants_to_music
(
	musicant_id uuid references musicants,
	music_id uuid references music,
	primary key(musicant_id, music_id)
);

insert into musicants_to_music(musicant_id, music_id)
values
((select id from musicants where last_name = 'prohochyova'), (select id from music where title = 'танец феи драже')),
((select id from musicants where last_name = 'zemlyanova'), (select id from music where title = 'лунная соната')),
((select id from musicants where last_name = 'komarov'), (select id from music where title = 'токката и фуга ре минор')),
((select id from musicants where last_name = 'komarov'), (select id from music where title = 'танец принца оршада и феи драже'));



select
	musicants.id,
	musicants.first_name, 
	musicants.last_name,
	musicants.date_born,
	coalesce (jsonb_agg(jsonb_build_object('id', m.id, 'title', m.title, 'genre', m.genre, 'duration', m.duration))
		filter(where m.id is not null), '[]') music
from musicants
left join musicants_to_music mm on musicants.id = mm.musicant_id
left join music m on m.id = mm.music_id
group by musicants.id;


select
	music.id,
	music.title, 
	music.genre,
	music.duration,
	coalesce (jsonb_agg(jsonb_build_object('id', ms.id, 'first_name', ms.first_name, 'last_name', ms.last_name, 'date_born', ms.date_born))
		filter(where ms.id is not null), '[]') musicants
from music
left join musicants_to_music mm on music.id = mm.music_id
left join musicants ms on ms.id = mm.musicant_id
group by music.id;






