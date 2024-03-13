-- ## Создать таблицы и задать связи, заполнить данными для следующих примеров:

-- ### 3. Мероприятия и участники:
-- - у мероприятия может быть много участников
-- - участник может посещать много мероприятий
-- - мероприятие - название, дата, место
-- - участник - имя, фамилия, дата рождения

-- ## Для каждого примера сделать вывод связанных сущностей - оба возможных варианта (например для сущностей актеры/фильмы нужно 1: для каждого актера вывести массив их фильмов, 2: для каждого фильма вывести массив их актеров)
-- - в качестве id нужно использовать uuid
-- - связанная сущность должна быть представлена в виде массива объектов
-- - учесть случай когда на строки в левой таблице может не быть ссылок

create extension if not exists "uuid-ossp";
drop table if exists event, participant, event_participant cascade;










create table event (
    id uuid PRIMARY key default uuid_generate_v4(),
    title VARCHAR(50),
    event_date DATE,
    place VARCHAR(50)
);

CREATE TABLE participant (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE
);

CREATE TABLE event_participant (
    event_id uuid REFERENCES event,
    participant_id uuid REFERENCES participant,
    PRIMARY KEY (event_id, participant_id)
);









insert into event (title, event_date, place)
VALUES
    ('Lekcia', '2024-03-13', 'Sirius'),
    ('Seminar', '2024-01-28', 'College Sirius'),
    ('Lotery', '2002-02-02', 'TV'),
    ('Birthday', '2007-01-01', 'Moscow')
;

insert into participant (first_name, last_name, date_of_birth)
VALUES
    ('Alexey', 'Zayceff', '2007-07-07'),
    ('Simon', 'Petrov', '2000-09-09'),
    ('Artyom', 'Krivenko', '2007-03-07'),
    ('Vadim', 'Sannikov', '20006-06-06')
;

insert into event_participant (event_id, participant_id)
VALUES
    ((select id from event where title = 'Lekcia'), (select id from participant where last_name = 'Zayceff')),
    ((select id from event where title = 'Seminar'), (select id from participant where last_name = 'Zayceff')),
    ((select id from event where title = 'Birthday'), (select id from participant where last_name = 'Zayceff')),
    ((select id from event where title = 'Lekcia'), (select id from participant where last_name = 'Sannikov')),
    ((select id from event where title = 'Seminar'), (select id from participant where last_name = 'Krivenko'))
;














select event.id, event.title, event.event_date,
    COALESCE(
        json_agg(
            jsonb_build_object(
                'participant id', participant.id, 'name', participant.first_name, 'last name', participant.last_name
                )
        )
        filter (WHERE participant.id is not null), '[]'
    )
    from event
    left join event_participant on event_participant.event_id = event.id
    left join participant on event_participant.participant_id = participant.id
    GROUP BY event.id;

select participant.id, participant.first_name, participant.last_name,
    COALESCE(
        json_agg(
            jsonb_build_object(
                'event id', event.id, 'event title', event.title, 'event_date', event.event_date
                )
        )
        filter (WHERE event.id is not null), '[]'
    )
    from participant
    left join event_participant on event_participant.participant_id = participant.id
    left join event on event_participant.event_id = event.id
    GROUP BY participant.id;