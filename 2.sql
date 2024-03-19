--    учащийся может решить много задач
--    задача может быть решена многими учащимися
--    задача - название, описание, сложность
--    учащийся - никнейм, дата регистрации, рейтинг

drop table student_to_task;

create extension if not exists "uuid-ossp";

drop table if exists actors, films, film_to_actor cascade;

create table task
(
    id         uuid primary key default uuid_generate_v4(),
    title text,
    description  text,
    complexity text
);

create table student
(
    id          uuid primary key default uuid_generate_v4(),
    nick_name       text,
    date_reg date,
    mmr        int
);

create table student_to_task
(
    student_id uuid references student,
    task_id  uuid references task,
    primary key (student_id, task_id)
);

insert into student(nick_name, date_reg, mmr)
values ('Froob', '1996-06-01', '1200'),
       ('Rubsun', '1976-07-19', '111111'),
       ('Bob228', '1956-11-22', '12'),
       ('Frozen', '2020-10-10','12'),
       ('Miro','2010-01-01', '12312');

insert into task (title, description, complexity)
values ('HW', 'HW1', 10),
       ('Прогулка', 'Прогулка на улице', 1),
       ('Тренеровка', 'Тренеровка на улице', 8);

insert into student_to_task(student_id, task_id)
values
    ((select id from student where nick_name = 'Froob'),
     (select id from task where title = 'HW')),
    ((select id from student where nick_name = 'Bob228'),
     (select id from task where title = 'Тренеровка')),
    ((select id from student where nick_name = 'Rubsun'),
     (select id from task where title = 'HW')),
    ((select id from student where nick_name = 'Miro'),
     (select id from task where title='Тренеровка'));


select
  s.id,
  s.nick_name,
  s.date_reg,
  s.mmr,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', t.id, 'title', t.title, 'description', t.description, 'complexity', t.complexity))
      filter (where t.id is not null), '[]') as tasks
from student s
left join student_to_task st on s.id = st.student_id
left join task t on t.id = st.task_id
group by s.id;



select
  t.id,
  t.title,
  t.description,
  t.complexity,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', s.id, 'nick_name', s.nick_name, 'date_teg', s.date_reg, 'mmr', s.mmr))
      filter (where s.id is not null), '[]') as students
from task t
left join student_to_task st on t.id = st.task_id
left join student s on s.id = st.student_id
group by t.id;
