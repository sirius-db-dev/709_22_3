drop table if exists taxist, zakaz cascade;
create table taxist
(
	id int primary key,
	name_t VARCHAR(50),
	surname VARCHAR(50),
	phone int,
	car text
);

create table zakaz
(
	id int primary key,
	taxist_id int REFERENCES taxist(id),
	nazvanie VARCHAR(50),
	date_z int,
	price int,
	adress_ot text,
	adress_kuda text
);

INSERT INTO taxist (id, name_t, surname, phone, car)
VALUES
(1, 'j', 'd', 89999978, 'Нива'),
(2, 'y', 'o', 899438978, 'Мерседес'),
(3, 'k', 'a', 892768098, 'Ауди');


INSERT INTO zakaz (id, taxist_id, nazvanie, date_z, adress_ot, adress_kuda)
VALUES
(1, 2,'Вова', 2024, 'Сириус', 'Воскресенская 12'),
(2, 2,'Иван', 2024, 'Сириус', 'Воскресенская 12'),
(3, 3,'Влад', 2024, 'оц', 'Воскресенская 18');



SELECT taxist.name_t, taxist.phone, taxist.car,
COALESCE(json_agg(json_build_object(zakaz.adress_ot, zakaz.adress_kuda)) FILTER (WHERE zakaz.taxist_id is NOT NULL)) as zakaz
from taxist
LEFT JOIN zakaz on zakaz.taxist_id = zakaz.id
GROUP BY taxist.id

--2

drop table if exists task, coment cascade;
create table task
(
	id int primary key,
	name_t VARCHAR(50),
	discription VARCHAR(100),
	lvl int
);

create table coment
(
	id int primary key,
	task_id int REFERENCES task(id),
	text_coment VARCHAR(500),
	date_c int
);

INSERT INTO task (id, name_t, discription, lvl)
VALUES
(1, 'Интеграл', 'Найти интеграл', 9),
(2, 'Производная', 'Найти производную', 7);



INSERT INTO coment (id, task_id, text_coment, date_c)
VALUES
(1, 1, 'Решил задачу через замену', 2024),
(2, 1, 'Помогло преобразование', 2023),
(3, 2, 'Домножил и получилось', 2003);



SELECT task.name_t, task.lvl,
COALESCE(json_agg(json_build_object(coment.text_coment, coment.date_c)) FILTER (WHERE coment.task_id is NOT NULL)) as coment
from task
LEFT JOIN coment on coment.task_id = coment.id
GROUP BY task.id



--3

drop table if exists obrach, coment cascade;
create table obrach
(
	id int primary key,
	number_o int,
	date_o int,
	status text
);

create table coment
(
	id int primary key,
	obrach_id int REFERENCES task(id),
	text_coment VARCHAR(500),
	date_c int
);

INSERT INTO obrach (id, number_o, date_o, status)
VALUES
(1, 87, 2025, 'Одобрено'),
(2, 88, 2026, 'На проверке');



INSERT INTO coment (id, obrach_id, text_coment, date_c)
VALUES
(1, 1, 'Помогите', 2025),
(2, 1, 'Не работает', 2025),
(3, 2, 'Все отлично', 2026);



SELECT obrach.number_o, obrach.status,
COALESCE(json_agg(json_build_object(coment.text_coment, coment.date_c)) FILTER (WHERE coment.obrach_id is NOT NULL)) as coment
from obrach
LEFT JOIN coment on coment.obrach_id = coment.id
GROUP by obrach.id
