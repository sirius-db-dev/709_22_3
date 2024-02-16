-- Task One
DROP TABLE IF EXISTS taxists, orders;
CREATE TABLE taxists
(
	id int PRIMARY KEY,
	name text,
	surname text,
	phone_number text,
	car text
);

INSERT INTO taxists
(id, name, surname, phone_number, car)
VALUES
(1, 'Oleg', 'Barodinov', '+79882885363', 'idk'),
(2, 'Artem', 'Voroshilov', '+78005553535', 'auto'),
(3, 'Kiril', 'Korolev', '+76538149975', 'car');

CREATE TABLE orders
(
	id int PRIMARY KEY,
	taxi_id int REFERENCES taxists(id),
	name text,
	date text,
	price float,
	start_address text,
	finish_address text
);

INSERT INTO orders
(id, taxi_id, name, date, price, start_address, finish_address)
VALUES
(1, 1, 'First', '16.02.2024', 500.0, 'Voskresenskya 12', 'Leninskaya 7'),
(2, 1, 'Second', '16.02.2024', 350.99, 'Dorojny 23', 'Pushkin 2'),
(3, 2, 'Third', '15.02.2024', 200.0, 'Kapriznino 83', 'Prostokvashino');

SELECT * FROM orders;
SELECT
	taxists.id AS taxist_id,
	id AS order_id,
	name,
	price,
	start_address,
	finish_address
FROM taxists
LEFT JOIN orders ON taxists.id = orders.taxi_id
GROUP BY taxists.id;


-- Task Two
DROP IF EXISTS chats, messanges;
CREATE TABLE chats
(
	id int PRIMARY KEY,
	name text,
	date text
);

INSERT INTO chats
(id, name, date)
VALUES
(1, 'Orders', '10.02.2024'),
(2, 'Taxists', '05.02.2024');

CREATE TABLE messanges
(
	id int PRIMARY KEY,
	chat_id REFERENCES chats(id),
	text text,
	date text
);

INSERT INTO messanges
(id, chat_id, text, date)
VALUES
(1, 1, 'Order id: 1, Oleg take this one.', '16.02.2024'),
(2, 1, 'Also take order id: 2, Oleg.', '16.02.2024'),
(3, 1, 'But I wanted take this order...', '16,02,2024'),
(4, 1, 'Artem, your order is id 3.', '16.02.2024'),
(5, 2, 'Test communication', '16.02.2024'),
(6, 2, 'Good, it is working.', '16.02.2024');

SELECT * FROM messanges;

SELECT
	chats.id AS chat_id,
	id AS messange_id,
	text,
	date
FROM chats
LEFT JOIN messanges ON chats.id = messanges.chat_id
GROUP BY chats.id;


-- Task Three
DROP TABLE IF EXISTS conferences, performances;
CREATE TABLE conferences
(
	id int PRIMARY KEY, 
	name text,
	date text,
	adress text
);

INSERT INTO conferences
(id, name, date, adress)
VALUES
(1, 'Science Standup', '20.02.2024', 'Broadway 13'),
(2, 'Animators Club', '25.02.2024', 'Broadway 23');

CREATE TABLE performances
(
	id int PRIMARY KEY,
	conference_id int REFERENCES conferences(id),
	name text,
	date text,
	theme text
);

INSERT INTO performances
(id, id_conference, name, date, theme)
VALUES
(1, 1, 'Dr. Who', '20.02.2024', 'The Time Paradox'),
(2, 1, 'Dr. Cleff', '21.02.2024', 'Quantum computers'),
(3, 2, 'Loginov', '25.02.2024', 'How 2 be not Pelmen in gradients'),
(4, 2, 'Vlad', '26.02.2024', 'Frames and smooth animation');

SELECT * FROM performances;

SELECT
	conferences.id AS conference_id,
	id AS performance_id,
	name, 
	date,
	theme
FROM confrences
LEFT JOIN performances ON conferences.id = performances.conference_id
GROUP BY conferences.id;

