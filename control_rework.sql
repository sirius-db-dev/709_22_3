-- task 1
DROP TABLE IF EXISTS performance, festival CASCADE;
CREATE TABLE festival
(
	id int PRIMARY KEY,
	title text,
	date_ text,
	place text
);

CREATE TABLE performance
(
	id int PRIMARY KEY,
	festival_id int REFERENCES festival(id),
	title text,
	date_ text,
	genre text
);

INSERT INTO festival
VALUES
(1, 'ВМФ', '01.03.2024', 'Sirius'),
(2, 'Animators club', '23.03.2024', 'Sochi'),
(3, 'HOMM3 club', '24.03.2024', 'Somewhere');

INSERT INTO performance
VALUES
(1, 1, 'How to art.', '01.03.2024', 'Art'),
(2, 1, 'How to write music', '01.03.2024', 'Music'),
(3, 2, 'About frames', '23.03.2024', 'Animation');

SELECT
	p.id,
	p.title,
	p.date_,
	p.genre,
	COALESCE(jsonb_agg(json_build_object(
	'id', f.id, 'title', f.title, 'date', f.date_, 'place', f.place))
	 FILTER (WHERE f.id IS NOT NULL), '[]') AS festival
FROM performance p
LEFT JOIN festival f on f.id = p.festival_id 
GROUP BY p.id;

-- task 2
DROP TABLE IF EXISTS team, employee CASCADE;
CREATE TABLE team
(
	id int PRIMARY KEY,
	title text,
	created text
);

CREATE TABLE employee
(
	id int PRIMARY KEY,
	team_id int REFERENCES team(id),
	name text,
	surname text,
	post text
);

INSERT INTO team
VALUES
(1, 'Rusty Iron Lung', '22.03.2024'),
(2, 'The Tech Book', '23.03.2024'),
(3, 'Alone Wolf', '24.03.2024'),
(4, 'Zero Team', '25.03.2024');

INSERT INTO employee
VALUES
(1, 1, 'Artem', 'Dragunov', 'FrontendDev'),
(2, 1, 'Rafael', 'Cecuj', 'Manager'),
(3, 2, 'Yaroslav', 'Loginov', 'BackendDev'),
(4, 2, 'Vadim', 'Voronov', 'DataStructuresDev'),
(5, 3, 'Danil', 'Matuhin', 'Gamer');

SELECT
	e.id,
	e.name,
	e.surname,
	e.post,
	COALESCE(jsonb_agg(jsonb_build_object(
	'id', t.id, 'title', t.title, 'created', t.created))
	FILTER (WHERE t.id IS NOT NULL), '[]') AS team
FROM employee e
LEFT JOIN team t on t.id = e.team_id
GROUP BY e.id;

-- task 3
DROP TABLE IF EXISTS video, usercomment CASCADE;
CREATE TABLE video
(
	id int PRIMARY KEY,
	title text,
	description text,
	public_date text
);

CREATE TABLE usercomment
(
	id int PRIMARY KEY,
	video_id int REFERENCES video(id),
	note text,
	likes int
);

INSERT INTO video
VALUES
(1, 'Cats', 'Cats playing with fluffy mouses', '22.03.2024'),
(2, 'Turtles', 'River turtles are having dinner', '23.03.2024'),
(3, 'Stoats', 'How to DO NOT misplay your technology card deck (Guide by pO3)', '24.03.2024'),
(4, 'Boring_Video', 'In this video we will talk about the projects...', '01.01.1997');

INSERT INTO usercomment
VALUES
(1, 1, 'Wow!', 7),
(2, 1, 'Where can I get such mice?', 21),
(3, 2, 'Cool turtles', 12),
(4, 3, 'This is absurd!', 29),
(5, 3, 'These are the rules, Leshy.', 42);

SELECT
	u.id,
	u.note,
	u.likes,
	COALESCE(jsonb_agg(jsonb_build_object(
	'id', v.id, 'title', v.title, 'description', v.description, 'published', v.public_date))
	FILTER (WHERE v.id IS NOT NULL), '[]') AS video
FROM usercomment u
LEFT JOIN video v on v.id = u.video_id
GROUP BY u.id;

