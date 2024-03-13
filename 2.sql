
-- учащийся может решить много задач
-- задача может быть решена многими учащимися
-- задача - название, описание, сложность
-- учащийся - никнейм, дата регистрации, рейтинг

create extension if not exists "uuid-ossp";

drop table if exists task, student, task_to_student;

create table if not exists task
(
    id uuid primary key default uuid_generate_v4(),
    title text,
    description text,
    complexity int
);

create table if not exists student
(
    id uuid primary key default uuid_generate_v4(),
    nickname text,
    registration_date date
    rating int
);

create table if not exists task_to_student
(
    task_id uuid references task,
    student_id uuid references student,
    primary key (task_id, student_id)
);

insert into task (title, description, complexity) values
('Интеграл', 'Найти под интегральное выражение', 9),
('Матрица', 'Посчитать матрицу', 5),
('Производные', 'Найти производную', 8),
('Пределы', 'Посчитать предел', 7);

insert into student (nickname, registration_date, rating) values
('zaiceff', '2019-07-15'),
('k0marov', '2023-08-30');

insert into task_to_student (task_id, student_id) values
((select id from task where title = 'Интеграл'),
 (select id from student where nickname = 'k0marov')),
((select id from task where title = 'Матрица'),
 (select id from student where nickname = 'zaiceff')),
((select id from task where title = 'Матрица'),
 (select id from student where nickname = 'k0marov')),
((select id from task where title = 'Пределы'),
 (select id from student where nickname = 'k0marov'));

select
    g.title,
    g.description,
    g.complexity,
    coalesce(jsonb_agg(jsonb_build_object(
        'nickname', b.nickname, 'registration_date', b.registration_date
        )) filter (where b.id is not null), '[]'
    ) as student
from task g
left join task_to_student gb on g.id = gb.task_id
left join student b on b.id = gb.buyer_id
group by g.id;

select
    b.nickname,
    b.registration_date,
    coalesce(jsonb_agg(jsonb_build_object(
        'title', g.title, 'description', g.description, 'complexity', g.complexity
        )) filter (where g.id is not null), '[]'
    ) as task
from student b
left join task_to_student gb on b.id = gb.student_id
left join task g on g.id = gb.task_id
group by b.id;
