-- ## Создать таблицы и задать связи, заполнить данными для следующих примеров:

-- ### 2. Доставки и курьеры:
-- - у доставки может быть много курьеров
-- - курьер может обслуживать несколько доставок
-- - доставка - название, телефон
-- - курьер - имя, фамилия, телефон, транспортное средство, объем сумки

-- ## Для каждого примера сделать вывод связанных сущностей - оба возможных варианта (например для сущностей актеры/фильмы нужно 1: для каждого актера вывести массив их фильмов, 2: для каждого фильма вывести массив их актеров)
-- - в качестве id нужно использовать uuid
-- - связанная сущность должна быть представлена в виде массива объектов
-- - учесть случай когда на строки в левой таблице может не быть ссылок






create extension if not exists "uuid-ossp";
drop table if exists delivery, courier, delivery_courier cascade;







create table delivery (
    id uuid PRIMARY key default uuid_generate_v4(),
    title VARCHAR(50),
    phone TEXT
);

CREATE TABLE courier (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone TEXT,
    vehicle VARCHAR(50),
    bag_volume float
);

CREATE TABLE delivery_courier (
    delivery_id uuid REFERENCES delivery,
    courier_id uuid REFERENCES courier,
    PRIMARY KEY (delivery_id, courier_id)
);







insert into delivery (title, phone)
VALUES
    ('delivery club', '+79999999999'),
    ('sber market', '+79999999998'),
    ('samokat', '+79999999997'),
    ('pyaterochka dostavka', '+79999999996')
;

insert into courier (first_name, last_name, phone, vehicle, bag_volume)
VALUES
    ('Ivan', 'Petrov', '+17899780980', 'Daewoo matis', 0.5),
    ('Afanasiy', 'Afanasiev', '+4337593875', 'Motorcycle', 5),
    ('Simon', 'Trofimoff', '+8687987545', 'Bicycle', 1),
    ('Sergey', 'Sidorov', '+788667689', 'Mercedes', 5)
;

insert into delivery_courier (delivery_id, courier_id) 
VALUES 
    ((SELECT id from delivery where title = 'delivery club'), (select id from courier where last_name = 'Petrov')),
    ((SELECT id from delivery where title = 'sber market'), (select id from courier where last_name = 'Petrov')),
    ((SELECT id from delivery where title = 'samokat'), (select id from courier where last_name = 'Petrov')),
    ((SELECT id from delivery where title = 'delivery club'), (select id from courier where last_name = 'Afanasiev'))
;







select delivery.id, delivery.title, delivery.phone,
    COALESCE(
        json_agg(
            jsonb_build_object(
                'courier id', courier.id, 'name', courier.first_name, 'vehicle', courier.vehicle
                )
        )
        filter (WHERE courier.id is not null), '[]'
    )
    from delivery
    left join delivery_courier on delivery_courier.delivery_id = delivery.id
    left join courier on delivery_courier.courier_id = courier.id
    GROUP BY delivery.id;


select courier.id, courier.first_name, courier.vehicle,
    COALESCE(
        json_agg(
            jsonb_build_object(
                'delivery id', delivery.id, 'title', delivery.title, 'phone', delivery.phone
                )
        )
        filter (WHERE delivery.id is not null), '[]'
    )
    from courier
    left join delivery_courier on delivery_courier.courier_id = courier.id
    left join delivery on delivery_courier.delivery_id = delivery.id
    GROUP BY courier.id;