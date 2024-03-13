create extension if not exists "uuid-ossp";

drop table if exists developers, repositories, rep_to_dev cascade;


create table developers
(
	id uuid primary key default uuid_generate_v4(),
	nickname text
);


insert into developers(nickname) values
	('Andrew'),
	('Leon'),
	('Maksimus'),
	('SF_228')
;



create table repositories
(
	id uuid primary key default uuid_generate_v4(),
	names text,
	description text,
	stars_quantity int
);


insert into repositories(names, description, stars_quantity) values
('709-22-3', 'rep for group 709-22-3', 5),
('709-22-2', 'rep for group 709-22-3', 4),
('709-22-1', 'rep for group 709-22-3', 5),
('The power engineer', 'rep for drink the power engineer', 1);

create table rep_to_dev
(
    rep_id uuid references repositories,
    developer_id  uuid references developers,
    primary key (rep_id, developer_id)
);


insert into rep_to_dev(rep_id, developer_id)
values
    ((select id from repositories where names = '709-22-3'),
     (select id from developers where nickname = 'Maksimus')),
    ((select id from repositories where names = '709-22-3'),
     (select id from developers where nickname = 'SF_228')),
    ((select id from repositories where names = '709-22-2'),
     (select id from developers where nickname = 'Maksimus')),
    ((select id from repositories where names = '709-22-1'),
     (select id from developers where nickname = 'Maksimus')),
    ((select id from repositories where names = '709-22-1'),
     (select id from developers where nickname = 'Andrew')),
	((select id from repositories where names = '709-22-2'),
     (select id from developers where nickname = 'Andrew'));

--1
select
  r.id,
  r.names,
  r.description,
  r.stars_quantity,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', d.id, 'nickname', d.nickname))
      filter (where d.id is not null), '[]') as developers
from repositories r
left join rep_to_dev rd on r.id = rd.rep_id
left join developers d on d.id = rd.developer_id
group by r.id;


--2
select
  d.id,
  d.nickname,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', r.id, 'names', r.names, 'description', r.description, 'stars quantity', r.stars_quantity))
      filter (where r.id is not null), '[]') as repositories
from developers d
left join rep_to_dev rd on d.id = rd.developer_id
left join repositories r on r.id = rd.rep_id
group by d.id;
