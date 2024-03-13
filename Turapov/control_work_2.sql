create extension if not exists "uuid-ossp";

drop table if exists videos, users, video_to_user cascade;

-- task1
create table videos
(
	id uuid primary key default uuid_generate_V4(),
	title text,
	pub_date text,
	duration text
);

create table users
(
	id uuid primary key default uuid_generate_V4(),
	nickname text,
	reg_date text
);

create table video_to_user
(
	video_id uuid references videos,
	user_id uuid references users,
	primary key (video_id, user_id)
);

insert into videos(title, pub_date, duration)
values  ('Cats', '13.03.2024', '9:24'),
		('Mouses', '12.03.2024', '7:26'),
		('Turtles', '12.03.2024', '5:48'),
		('Boring video', '05.02,2024', '59:59');
	
insert into users(nickname, reg_date)
values  ('Ivan11', '01.02.2024'),
		('Vor0n0v', '11.09.2023'),
		('user_1234', '05.07.2022');

insert into video_to_user(video_id, user_id)
values
	((select id from videos where title='Cats'),
	(select id from users where nickname='Ivan11')),
	((select id from videos where title='Cats'),
	(select id from users where nickname='Vor0n0v')),
	((select id from videos where title='Cats'),
	(select id from users where nickname='user_1234')),
	((select id from videos where title='Mouses'),
	(select id from users where nickname='Ivan11')),
	((select id from videos where title='Mouses'),
	(select id from users where nickname='Vor0n0v')),
	((select id from videos where title='Turtles'),
	(select id from users where nickname='user_1234'));

select
	u.id,
	u.nickname,
	u.reg_date,
	coalesce(jsonb_agg(json_build_object(
	'id', v.id, 'title', v.title, 'pub_date', v.pub_date, 'duration', v.duration))
	 filter (where v.id is not null), '[]') as videos
from users u
left join video_to_user vu on u.id = vu.user_id 
left join videos v on v.id = vu.video_id 
group by u.id;
	
-- task2
drop table if exists products, stocks, stock_to_product cascade;

create table products
(
	id uuid primary key default uuid_generate_V4(),
	title text,
	price float,
	category text
);

create table stocks
(
	id uuid primary key default uuid_generate_V4(),
	title text,
	discount text,
	opened_date text,
	closed_date text
);

create table stock_to_product
(
	product_id uuid references products,
	stock_id uuid references stocks,
	primary key (product_id, stock_id)
);

insert into products(title, price, category)
values  ('Cheese', 89.0, 'Tvorog'),
		('Yogurt', 69.99, 'Milk'),
		('Steak', 233.0, 'Meat'),
		('Boot', 0.0, 'Garbage');
	
insert into stocks(title, discount, opened_date, closed_date)
values  ('Cow gift!', '30%', '10.03.2024', '13.03.2024'),
		('Black friday', '50%', '12.03.2024', '14.03.2024');

insert into stock_to_product(product_id, stock_id)
values
	((select id from products where title='Cheese'),
	(select id from stocks where title='Cow gift!')),
	((select id from products where title='Yogurt'),
	(select id from stocks where title='Cow gift!')),
	((select id from products where title='Steak'),
	(select id from stocks where title='Black friday'));

select
	s.id,
	s.title,
	s.discount,
	s.opened_date,
	s.closed_date,
	coalesce(jsonb_agg(json_build_object(
	'id', p.id, 'title', p.title, 'price', p.price, 'category', p.category))
	 filter (where p.id is not null), '[]') as products
from stocks s
left join stock_to_product sp on s.id = sp.stock_id 
left join products p on p.id = sp.product_id 
group by s.id;

-- task3
drop table if exists recipes, ingredients, ingredient_to_recipe cascade;

create table recipes
(
	id uuid primary key default uuid_generate_V4(),
	title text,
	description text,
	category text
);

create table ingredients
(
	id uuid primary key default uuid_generate_V4(),
	title text,
	category text,
	price float
);

create table ingredient_to_recipe
(
	ingredient_id uuid references ingredients,
	recipe_id uuid references recipes,
	primary key (ingredient_id, recipe_id)
);

insert into recipes(title, description, category)
values  ('Cake', 'Delicios cake', 'Bakery'),
		('Pancakes', 'Pancakes with chocolate', 'Bakery'),
		('Pies', 'Pies with something', 'Bakery'),
		('Kvass', 'Kvass with live yeast', 'Drinks'),
		('Tvorog', 'Soft tvorog', 'Milk');
	
insert into ingredients(title, category, price)
values  ('Flour', 'Wheat', 50.0),
		('Yeasts', 'Wheat', 32.0),
		('Eggs', 'Chicken', 112.0),
		('Chocolate', 'Sweets', 69.99),
		('Milk', 'Milky', 89.00);

insert into ingredient_to_recipe(ingredient_id, recipe_id)
values
	((select id from ingredients where title='Flour'),
	(select id from recipes where title='Cake')),
	((select id from ingredients where title='Flour'),
	(select id from recipes where title='Pancakes')),
	((select id from ingredients where title='Flour'),
	(select id from recipes where title='Pies')),
	((select id from ingredients where title='Yeasts'),
	(select id from recipes where title='Cake')),
	((select id from ingredients where title='Yeasts'),
	(select id from recipes where title='Pancakes')),
	((select id from ingredients where title='Yeasts'),
	(select id from recipes where title='Pies')),
	((select id from ingredients where title='Yeasts'),
	(select id from recipes where title='Kvass')),
	((select id from ingredients where title='Eggs'),
	(select id from recipes where title='Cake')),
	((select id from ingredients where title='Eggs'),
	(select id from recipes where title='Pancakes')),
	((select id from ingredients where title='Chocolate'),
	(select id from recipes where title='Pancakes'));
	
select
	r.id,
	r.title,
	r.description,
	coalesce(jsonb_agg(json_build_object(
	'id', i.id, 'title', i.title, 'price', i.price))
	 filter (where i.id is not null), '[]') as ingredients
from recipes r
left join ingredient_to_recipe ir on r.id = ir.recipe_id 
left join ingredients i on i.id = ir.ingredient_id 
group by r.id;
