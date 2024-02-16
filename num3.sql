drop table if exists comand, staff, from_comand_to_staff cascade;

create table comand
(
	id int primary key,
	title text,
	date_create date	
);

insert into comand(id, title, date_create)
values
(1, 'comand1', '2022.01.03'),
(2, 'comand2', '2022.01.02'),
(3, 'comand3', '2022.01.01'),
(4, 'comand4', '1892.05.26');

create table staff
(
	id int primary key,
	name text,
	surname text,
	post text
);

insert into staff(id, name, surname, post)
values
(1, 'lyosha', 'zaitsev', 'разработчик'),
(2, 'seryoga', 'telegin', 'тоже разработчик'),
(3, 'sasha', 'ivanov', 'дизайнер');

create table from_comand_to_staff
(
	comand_id int references comand,
	staff_id int references staff,
	primary key(comand_id, staff_id) 
);

insert into from_comand_to_staff(comand_id, staff_id)
values
(1, 2),
(2, 3),
(3, 1);

select
	comand.id,
	comand.title, 
	comand.date_create,
	coalesce (jsonb_agg(jsonb_build_object('id', s.id, 'name', s.name, 'surname',
		s.surname, 'post', s.post))
		filter(where s.id is not null), '[]') staff
from comand
left join from_comand_to_staff fos on comand.id = fos.comand_id
left join staff s on s.id = fos.staff_id
group by comand.id;



