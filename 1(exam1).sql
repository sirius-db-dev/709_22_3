--Пациенты и визиты:

--    пациент может иметь несколько визитов
--    визит может принадлежать только одному пациенту
--    пациент - имя, фамилия, дата рождения, пол
--    визит - дата, диагноз




create table patient
(
	id int primary key,
	f_name text,
	l_name text,
	birthday date,
	gender text
);


create table visit
(
	id int primary key,
	patient_id int references patient,
	date date,
	diagnosis text
);


insert into patient(id, f_name, l_name, birthday, gender) values
(1, 'Maksim', 'Nudga', '2006-04-02', 'M'),
(2, 'ALex', 'Bobich', '1999-10-02', 'M'),
(3, 'Marina', 'Tutkova', '1980-01-28', 'Ж'),
(4, 'Bob', 'NotBob', '2010-09-21', 'M');


insert into visit(id, patient_id, date, diagnosis) values
(1, 1,'2024-01-01', 'Отравление оливье'),
(2, 2,'2022-05-28', 'Перелом'),
(3, 1, '2013-09-12', 'Температура');


select  * from patient ;
select * from visit;


select 
	p.id,
	p.f_name,
	p.l_name,
	p.birthday,
	p.gender,
	coalesce (jsonb_agg(json_build_object(
	'id', v.id, 'date', v.date, 'diagnosis', v.diagnosis))
	filter (where v.id is not null), '[]') as visits
from patient p
left join visit v on p.id = v.patient_id
group by p.id;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	