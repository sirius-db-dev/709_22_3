--task 1
drop table if exists videos, comments cascade;


create table videos (
	id int primary key,
	name varchar(255),
	discribe varchar(255),
	date date
);

create table comments (
	id int primary key,
	text varchar(255),
	licks int,
	video_id int references videos
);

insert into videos (
	values (1, 'rap', 'cool', '1976-07-19'),
	(2, 'school', 'not cool', '1976-07-18')
);

insert into comments (
	values (1, 'oooe omg', 10, 1),
	(2, 'oooyyy wooow', 9, 1)
);

select 
v.id,
v.name,
v.discribe,
v.date,
coalesce(json_agg(json_build_object(
	'id', c.id, 'text', c.text, 'licks', c.licks))
	filter (where c.video_id is not null), '[]')
as comments
from videos v
left join comments c on v.id = c.video_id
group by v.id;



--task 2
drop table if exists books, reviews cascade;


create table books (
	id int primary key,
	name varchar(255),
	genre varchar(255),
	date int
);

create table reviews (
 	id int primary key,
 	text varchar(255),
 	mark int,
 	book_id int references books
);

insert into books (
	values (1, 'love', 'cool', 1976),
	(2, 'time', 'not cool', 1978)
);


insert into reviews (
	values (1, 'good', 5, 1),
	(2, 'woow', 10, 1)	
);

select 
	b.id,
	b.name,
	b.genre,
	b.date,
	coalesce(json_agg(json_build_object(
	'id', r.id, 'text', r.text, 'marck', r.mark))
	filter (where r.book_id is not null), '[]')
	as reviews
from books b
left join reviews r on b.id = r.book_id
group by b.id;



--task 3 
drop table if exists couriers, orders cascade;

create table couriers (
	id int primary key,
	name varchar(255),
	surname varchar(255),
	number varchar(255)
);

create table orders (
	id int primary key,	
	address varchar(255),
	date date,
	status varchar(255),
	courier_id int references couriers
);

insert into couriers (
	values (1, 'Vasya', 'Vasiliev', '8 800'),
	(2, 'Sergei', 'Sergeev', '555 35 35')
);

insert into orders (
	values (1, 'Lenina', '1976-07-19', 'delivered', 1),
	(2, 'Vysotskоgo', '1976-07-18', 'on way', 1)
);

select 
	c.id,
	c.name,
	c.surname,
	c.number,
	coalesce(json_agg(json_build_object(
	'id', o.id, 'address', o.address, 'date', o.date, 'status', o.status))
	filter (where o.courier_id is not null), '[]')
	as orders
from couriers c
left join orders o on c.id = o.courier_id
group by c.id;








