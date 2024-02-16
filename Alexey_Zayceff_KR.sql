-- 1)
drop TABLE if EXISTS Book, reviews CASCADE;
create Table Book
(
    id int PRIMARY KEY,
    book_name VARCHAR(50),
    zhanr VARCHAR(50),
    god_izdania int
);

CREATE Table reviews
(
    id int PRIMARY KEY,
    book_id int REFERENCES Book(id),
    text_data TEXT,
    mark int
);

INSERT INTO Book (id, book_name, zhanr, god_izdania)
VALUES
(1, 'Math for 2nd class', 'Studying', 2006),
(2, 'Network and protocols', 'Computer Science', 2001),
(3, 'Basic of computer science', 'Computer Science', 1999);

INSERT INTO reviews (id, book_id, text_data, mark)
VALUES
(1, 1, 'Good book', 5),
(2, 1, 'Bad book', -1),
(3, 3, 'Normal', 3);

SELECT Book.book_name, Book.god_izdania,
COALESCE(json_agg(json_build_object('text or review', reviews.text_data, 'mark', reviews.mark)) FILTER (WHERE reviews.book_id is NOT NULL), '[]') as review
from book
LEFT JOIN reviews on reviews.book_id = Book.id
GROUP BY Book.id



-- ### 2. Задачи и комментарии:
-- - задача может иметь несколько комментариев
-- - комментарий может принадлежать только одной задаче
-- - задача - название, описание, сложность
-- - комментарий - текст, дата публикации
DROP TABLE if EXISTS task, comment_ CASCADE;

CREATE TABLE task
(
    id int PRIMARY KEY,
    task_name VARCHAR(50),
    task_description text,
    difficult int
);

CREATE TABLE comment_
(
    id int PRIMARY KEY,
    task_id int REFERENCES task,
    comment_text text,
    publishing_data DATE
);

INSERT INTO task (id, task_name, task_description, difficult)
VALUES
(1, 'Data Base HW', 'main task', 1),
(2, 'Gym', '1000 x stomach cranch', 1000),
(3, 'Get stipendia', 'need good marks', 1000000);

INSERT INTO comment_ (id, task_id, comment_text, publishing_data)
VALUES
(1, 1, 'easy', '2024.2.16'),
(2, 3, 'very difficult', '1999.9.9'),
(3, 3, 'impossible', '2024.1.1');

SELECT task.id, task.task_name, task.task_description, task.difficult,
COALESCE(json_agg(json_build_object('comment', comment_.comment_text, 'date', comment_.publishing_data)) FILTER (WHERE comment_.task_id is NOT NULL), '[]') as Comment
from task
LEFT JOIN comment_ on comment_.task_id = task.id
GROUP BY task.id;


-- ### 3. Обращения и комментарии:
-- - обращение может иметь несколько комментариев
-- - комментарий может принадлежать только одному обращению
-- - обращение - номер, дата, статус
-- - комментарий - текст, дата публикации

DROP TABLE if EXISTS appeal, appeal_comments CASCADE;
CREATE TABLE appeal
(
    id INT PRIMARY KEY,
    number_ int UNIQUE,
    appeal_date DATE,
    appeal_status VARCHAR(50)
);

CREATE TABLE appeal_comments
(
    id INT PRIMARY KEY,
    appeal_number int REFERENCES appeal(number_),
    comment_text TEXT,
    publishing_date DATE
);

INSERT INTO appeal (id, number_, appeal_date, appeal_status)
VALUES
(1, 1, '1990.1.1', 'in process'),
(2, 2, '1991.1.1', 'complete'),
(3, 3, '2000.1.1', 'start handling');

INSERT INTO appeal_comments (id, appeal_number, comment_text, publishing_date)
VALUES
(1, 1, 'random text', '2005.1.1'),
(2, 1, '2', '2006.1.1'),
(3, 3, '3', '2007.1.1');

SELECT appeal.number_, appeal.appeal_date, appeal.appeal_status,
COALESCE(json_agg(json_build_object('comment', appeal_comments.comment_text, 'date', appeal_comments.publishing_date)) FILTER (WHERE appeal_comments.appeal_number is NOT NULL), '[]') as Comment
from appeal
LEFT JOIN appeal_comments on appeal.number_ = appeal_comments.appeal_number
GROUP BY appeal.id;









