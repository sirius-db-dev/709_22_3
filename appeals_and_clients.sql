create extension if not exists "uuid-ossp";

drop table if exists clients, appeals, client_to_appeal cascade;


create table clients
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	phone_num text
);


insert into clients(first_name, last_name, phone_num) values
('Andrew', 'Holland', '+79864567235'),
('Leon', 'Kambulatov', '+73457435672'),
('Maksim', 'Nugalaev', '+45678263498'),
('Sergey', 'Mainov', '+53293257592');



create table appeals
(
	id uuid primary key default uuid_generate_v4(),
	ap_number int,
	ap_date date,
	status text
);


insert into appeals(ap_number, ap_date, status) values
(1, '2019-5-12', 'ready'),
(2, '2019-6-16', 'ready'),
(3, '2023-1-25', 'in development'),
(4, '2024-3-13', 'in drafting');

create table client_to_appeal
(
    client_id uuid references clients,
    appeal_id  uuid references appeals,
    primary key (client_id, appeal_id)
);


insert into client_to_appeal(client_id, appeal_id)
values
    ((select id from clients where phone_num = '+79864567235'),
     (select id from appeals where ap_number = 1)),
    ((select id from clients where phone_num = '+79864567235'),
     (select id from appeals where ap_number = 2)),
    ((select id from clients where phone_num = '+79864567235'),
     (select id from appeals where ap_number = 4)),
    ((select id from clients where phone_num = '+45678263498'),
     (select id from appeals where ap_number = 1)),
    ((select id from clients where phone_num = '+45678263498'),
     (select id from appeals where ap_number = 4)),
    ((select id from clients where phone_num = '+53293257592'),
     (select id from appeals where ap_number = 4));
	

--1
select
  c.id,
  c.first_name,
  c.last_name,
  c.phone_num,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', ap.id, 'number', ap.ap_number, 'date', ap.ap_date, 'status', ap.status))
      filter (where ap.id is not null), '[]') as appeals
from clients c
left join client_to_appeal cap on c.id = cap.client_id
left join appeals ap on ap.id = cap.appeal_id
group by c.id;


--2
select
  ap.id,
  ap.ap_number,
  ap.ap_date,
  ap.status,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', c.id, 'first name', c.first_name, 'last name', c.last_name, 'phone number', c.phone_num))
      filter (where c.id is not null), '[]') as clients
from appeals ap
left join client_to_appeal cap on ap.id = cap.appeal_id
left join clients c on c.id = cap.client_id
group by ap.id;








