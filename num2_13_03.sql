create extension if not exists "uuid-ossp";

drop table if exists pages, users, pages_to_users cascade;


create table pages
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	date_public date,
	words text
);

insert into pages(title, date_public, words)
values
('page1', '2006-12-10', 'hello'),
('page2', '2007-11-07', 'привет'),
('page3', '2008-10-09', 'aaaaaa'),
('page4', '2009-04-05', 'prik');


create table users
(
	id uuid primary key default uuid_generate_v4(),
	nik_name text,
	date_reg date
);

insert into users(nik_name, date_reg)
values
('katya', '2004-08-03'),
('nastya', '2004-09-02'),
('semyon', '2005-06-01'),
('misha', '2008-04-09');

create table pages_to_users
(
	page_id uuid references pages,
	user_id uuid references users,
	primary key(user_id, page_id)
);

insert into pages_to_users
values
((select id from pages where title = 'page1'), (select id from users where nik_name = 'katya')),
((select id from pages where title = 'page4'), (select id from users where nik_name = 'nastya')),
((select id from pages where title = 'page2'), (select id from users where nik_name = 'misha')),
((select id from pages where title = 'page3'), (select id from users where nik_name = 'misha'));


select
	users.id,
	users.nik_name, 
	users.date_reg,
	coalesce (jsonb_agg(jsonb_build_object('id', p.id, 'title', p.title, 'date_public', p.date_public, 'words', p.words))
		filter(where p.id is not null), '[]') pages
from users
left join pages_to_users pu on users.id = pu.user_id
left join pages p on p.id = pu.page_id
group by users.id;

select
	pages.id,
	pages.title, 
	pages.date_public,
	pages.words,
	coalesce (jsonb_agg(jsonb_build_object('id', u.id, 'nik_name', u.nik_name, 'date_reg', u.date_reg))
		filter(where u.id is not null), '[]') users
from pages
left join pages_to_users pu on pages.id = pu.page_id
left join users u on u.id = pu.user_id
group by pages.id;


















