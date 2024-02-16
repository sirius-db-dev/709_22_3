drop table if exists chats, message;

create table chats
(
	id int primary key,
	title text,
	date_create date
);

insert into chats(id, title, date_create)
values
(1, 'K0709-22/3', '2022.01.03'),
(2, 'K0709-22/2', '2022.01.02'),
(3, 'K0709-22/1', '2022.01.01'),
(4, 'group 101', '1892.05.26');

create table message
(
	id int primary key,
	msg text,
	date_send date,
	chat_id int references chats
);

insert into message(id, msg, date_send, chat_id)
values
(1, 'hello', '2024.12.06', 2),
(2, 'привет', '2024.11.27', 1),
(3, 'как дела', '2024.08.02', 3);

select
	chats.id,
	chats.title, 
	chats.date_create,
	coalesce (jsonb_agg(jsonb_build_object('id', m.id, 'msg', m.msg, 'date_send', m.date_send, 'chat_id', m.chat_id))
		filter(where m.id is not null), '[]') message
from chats
left join message m on chats.id = m.chat_id
group by chats.id;








