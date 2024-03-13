--    в фестивале могут принимать участие несколько людей
--    человек может принимать участие в нескольких фестивалях
--    фестиваль - название, дата, место
--    человек - имя, фамилия, дата рождения

create extension if not exists "uuid-ossp";

create table if not exists fest
(
    id         uuid primary key default uuid_generate_v4(),
    title text,
    date date,
    place text
);


create  table if not exists person
(
    id         uuid primary key default uuid_generate_v4(),
    first_name text,
    last_name text,
    birthdate date
);

create table if not exists fest_to_person
(
    person_id uuid references person,
    fest_id uuid references fest
);


insert into fest(title, date, place) values
('VK fest', '2023-02-23', 'Sirius'),
('ВФМ', '2024-03-01', 'Sirius');

insert into person (first_name, last_name, birthdate) values
('Maksim', 'Nudga', '2006-02-04'),
('Sergo', 'Telegin', '2006-10-9');


insert into fest_to_person (person_id, fest_id)
values
    ((select id from person where first_name = 'Maksim'),
     (select id from fest where title = 'VK fest')),
    ((select id from person where first_name = 'Sergo'),
     (select id from fest where title = 'ВФМ'));

select
    person.id,
    person.first_name,
    person.last_name,
    person.birthdate,
    coalesce(json_agg(json_build_object(
                      'id', fest.id, 'title', fest.title, 'date', fest.date))
                        filter ( where fest.id is not null ), '[]') as fests
from person
left join fest_to_person ftp on person.id = ftp.person_id
left join fest on fest.id = ftp.fest_id
group by person.id;


select
    fest.id,
    fest.title,
    fest.date,
    fest.place,
    coalesce(json_agg(json_build_object(
                      'id', person.id, 'name', person.first_name, 'last_name', person.last_name))
                      filter ( where person.id is not null), '[]' ) as persons
from fest
left join fest_to_person ftp on fest.id = ftp.fest_id
left join person on person.id = ftp.person_id
group by fest.id;
