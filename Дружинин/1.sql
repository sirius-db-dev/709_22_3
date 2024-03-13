create extension if not exists "uuid-ossp";

create table events
(
    id      uuid primary key default uuid_generate_v4(),
    title   text,
    date    date,
    place   text
);

create table participants
(
    id          uuid primary key default uuid_generate_v4(),
    name        text,
    surname     text,
    birthday    date
);

create table event_to_participant
(
    event_id uuid references events,
    participant_id uuid references participants,
    primary key (event_id, participant_id)
);

insert into events(title, date, place) values
('Ярмарка', '2024-05-20', 'Череповец'),
('Выставка талантов', '2024-06-21', 'Вологда'),
('Концерт', '2024-03-16', 'Москва'),
('Открытие метро', '2024-05-23', 'Питер');

insert into participants(name, surname, birthday) values
('Никита', 'Иванович', '2000-03-25'),
('Иван', 'Георг', '1999-08-20'),
('Роберт', 'Маленький', '2001-06-15'),
('Петр', 'Ярмола', '2000-01-09');

insert into event_to_participant(event_id, participant_id) values
((select id from events where title = 'Ярмарка'),
 (select id from participants where surname = 'Иванович')),
((select id from events where title = 'Выставка талантов'),
 (select id from participants where surname = 'Иванович')),
((select id from events where title = 'Ярмарка'),
 (select id from participants where surname = 'Георг')),
((select id from events where title = 'Выставка талантов'),
 (select id from participants where surname = 'Георг')),
((select id from events where title = 'Открытие метро'),
 (select id from participants where surname = 'Маленький')),
((select id from events where title = 'Концерт'),
 (select id from participants where surname = 'Георг')),
((select id from events where title = 'Концерт'),
 (select id from participants where surname = 'Иванович'));

select
    p.id,
    p.name,
    p.surname,
    p.birthday,
    coalesce(jsonb_agg(jsonb_build_object(
    'id', e.id, 'title', e.title, 'date', e.date, 'place', e.place))
      filter (where e.id is not null), '[]') as events
from participants p
left join event_to_participant etp on p.id = etp.participant_id
left join events e on e.id = etp.event_id
group by p.id;

select
    e.id,
    e.title,
    e.date,
    e.place,
    coalesce(jsonb_agg(jsonb_build_object(
    'id', p.id, 'name', p.name, 'surname', p.surname, 'birthday', p.birthday))
      filter (where p.id is not null), '[]') as participants
from events e
left join event_to_participant etp on e.id = etp.event_id 
left join participants p on p.id = etp.participant_id
group by e.id;