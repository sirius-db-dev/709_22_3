--Обращения и комментарии:
--
--    обращение может иметь несколько комментариев
--    комментарий может принадлежать только одному обращению
--    обращение - номер, дата, статус
--    комментарий - текст, дата публикации


create table appeal
(
	id int primary key,
	number int,
	date date, 
	status text
);

create table comment
(
	id int primary key,
	appeal_id int references appeal,
	text text,
	date_of_publish date
);


insert into appeal(id, number, date, status) values
(1, 10, '2023-10-23', 'Finish'),
(2, 11, '2023-11-29', 'In process'),
(3, 15, '2024-01-05', 'In process'),
(4, 29, '2013-08-01', 'Finish');


insert into  comment(id, appeal_id, text, date_of_publish) values
(1, 3, 'Слишком долго', '2024-01-10'),
(2, 3, 'Плохое качество сборки', '2024-01-20'),
(3, 3, 'Не рекомендую', '2024-01-21'),
(4, 1, 'Рекомендую', '2023-10-24');


select 
	a.id,
	a.number,
	a.date,
	a.status,
	coalesce(jsonb_agg(jsonb_build_object(
	'id', c.id, 'text', c.text, 'date_of_publish', c.date_of_publish))
	filter (where c.id is not null), '[]') as comments
from appeal a
left join comment c on a.id = c.appeal_id
group by a.id;