--
--    у мероприятия может быть много участников
  --  участник может посещать много мероприятий
    --мероприятие - название, дата, место
   -- участник - имя, фамилия, дата рождения

create extension if not exists "uuid-ossp";


drop table member, event, member_to_event;

create table event
(
    id uuid primary key default uuid_generate_v4(),
    title text,
    place text
);

create table member
(
    id uuid primary key default uuid_generate_v4(),
    first_name text,
    last_name text,
    birthdate date
);

create table member_to_event
(
    member_id uuid references member,
    event_id uuid references event,
    primary key (member_id, event_id)
);


insert into event (title, place) values
('Новый год', 'Дом'),
('Запуск ракеты', 'Космодром'),
('День Победы', 'Кремль'),
('ДР', 'Sigma'),
('Падение метеорита', 'Челябинск');


insert into member (first_name, last_name, birthdate) values
('Maksim', 'Nudga', '2006-02-04'),
('Sergo', 'Telegin', '2006-10-09'),
('foo', 'bar', '1999-02-22'),
('fizz','buzz','2013-02-15'),
('Oleg', 'Kus', '1989-09-28');



insert into member_to_event(member_id, event_id)
values
    ((select id from member where first_name = 'Maksim'),
     (select id from event where title = 'День Победы')),
    ((select id from member where first_name = 'foo'),
     (select id from event where title = 'День Победы')),
    ((select id from member where first_name = 'Sergo'),
     (select id from event where title = 'ДР')),
    ((select id from member where first_name = 'Maksim'),
     (select id from event where title = 'ДР')),
    ((select id from member where first_name = 'fizz'),
     (select id from event where title = 'День Победы'));



select
  s.id,
  s.first_name,
  s.last_name,
  s.birthdate,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', t.id, 'title', t.title, 'place', t.place))
      filter (where t.id is not null), '[]') as events
from member s
left join member_to_event st on s.id = st.member_id
left join event t on t.id = st.event_id
group by s.id;



select
  s.id,
  s.title,
  s.place,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', t.id, 'first_name', t.first_name, 'last_name', t.last_name, 'birthdate', t.birthdate))
      filter (where t.id is not null), '[]') as members
from event s
left join member_to_event st on s.id = st.event_id
left join member t on t.id = st.member_id
group by s.id;



