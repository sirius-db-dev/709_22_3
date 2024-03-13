
-- ## Создать таблицы и задать связи, заполнить данными для следующих примеров:

-- ### 1. Курсы и студенты
-- - курсы могут проходить несколько студентов
-- - студент может проходить нескольких курсах
-- - курс - название, описание
-- - студент - имя, фамилия, год поступления



-- ## Для каждого примера сделать вывод связанных сущностей - оба возможных варианта (например для сущностей актеры/фильмы нужно 1: для каждого актера вывести массив их фильмов, 2: для каждого фильма вывести массив их актеров)
-- - в качестве id нужно использовать uuid
-- - связанная сущность должна быть представлена в виде массива объектов
-- - учесть случай когда на строки в левой таблице может не быть ссылок


create extension if not exists "uuid-ossp";
drop table if exists course, student, course_student cascade;


create table course (
    id uuid PRIMARY key default uuid_generate_v4(),
    title VARCHAR(50),
    description TEXT
);

CREATE TABLE student (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    enrollment_year int
);

CREATE TABLE course_student (
    course_id uuid REFERENCES course,
    student_id uuid REFERENCES student,
    PRIMARY KEY (course_id, student_id)
);


INSERT into course (title, description)
VALUES
    ('Math', 'VERY HARD'),
    ('English', 'Are you from England?'),
    ('DataBase', 'TEACHER - SIGMA'),
    ('Programming', 'Smart')
;

INSERT INTO student (first_name, last_name, enrollment_year)
VALUES
    ('Alexey', 'Zayceff', 2022),
    ('Michael', 'Noskov', 2022),
    ('Vasya', 'Pupkin', 1700)
;

insert into course_student (course_id, student_id)
VALUES
    ((select id from course where title = 'DataBase'), (select id from student where last_name = 'Zayceff')),
    ((select id from course where title = 'Math'), (select id from student where last_name = 'Zayceff')),
    ((select id from course where title = 'English'), (select id from student where last_name = 'Zayceff')),
    ((select id from course where title = 'DataBase'), (select id from student where last_name = 'Noskov'))
;



select course.id, course.title, course.description,
    COALESCE(
        json_agg(
            jsonb_build_object(
                'student id', student.id, 'name', student.first_name, 'year of enrollement', student.enrollment_year
                )
        )
        filter (WHERE student.id is not null), '[]'
    )
    from course
    left join course_student on course_student.course_id = course.id
    left join student on course_student.student_id = student.id
    GROUP BY course.id;



select student.id, student.first_name, student.last_name,
    COALESCE(
        json_agg(
            jsonb_build_object(
                'course id', course.id, 'title', course.title, 'description', course.description
                )
        )
        filter (WHERE course.id is not null), '[]'
    )
    from student
    left join course_student on course_student.student_id = student.id
    left join course on course_student.course_id = course.id
    GROUP BY student.id;