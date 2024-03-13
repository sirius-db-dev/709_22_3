-- врач может лечить несколько пациентов
-- пациент может лечиться у нескольких врачей
-- врач - имя, фамилия, специализация
-- пациент - имя, фамилия, дата рождения

create extension if not exists 'uuid'

drop table exists doctor, patient, doctor_to_patient

create table if not exists doctor
(
    id uuid primary key default uuid_generate_v4(),
    name_f text,
    surname text,
    specialization text
);

create table if not exists patient
(
    id uuid primary key default uuid_generate_v4(),
    name_f text,
    surname_p text,
    date_of_brthd date
)

create table if not exists doctor_to_patient
(
    doctor_id uuid references doctor,
    patient_id uuid references patient,
    primary key (doctor_id, patient_id)
);


insert into doctor (name_f, surname, specialization) values
('Алексей', 'Зайцев', 'Терапевт'),
('Сергей', 'Телегин', 'Хирург'),
('Максим', 'Нудьга', 'Педиатр'),
('Виктория', 'Пазыч', 'Остеопат');

insert into recipes (name_f, surname_p, date_of_brthd) values
('Семен', 'Комаров', '2006-08-02'),
('Артём', 'Терешин', '2006-12-20');


insert into doctor_to_patient (doctor_id, patient_id) values
((select id from doctor where name_f = 'Алексей'),
 (select id from patient where name_f = 'Семен')),
((select id from doctor where name_f = 'Алексей'),
 (select id from patient where name_f = 'Артем')),
((select id from doctor where name_f = 'Максим'),
 (select id from patient where name_f = 'Артём')),
((select id from doctor where name_f = 'Виктория'),
 (select id from patient where name_f = 'Семен'));

select
    i.name_f,
    i.surname,
    i.specialization,
    coalesce(jsonb_agg(jsonb_build_object(
        'name', r.name, 'surname', r.surname_p, 'surname', r.surname
        )) filter (where r.id is not null), '[]'
    ) as used_in
from doctor i
left join doctor_to_patient ir on i.id = ir.doctor_id
left join patient r on r.id = ir.patient_id
group by i.id;

select
    r.name_f,
    r.surname_p,
    r.date_of_brthd,
    coalesce(jsonb_agg(jsonb_build_object(
        'name_f', i.name_f, 'date_of_brthd', i.date_of_brthd, 'specialization', i.specialization
        )) filter (where i.id is not null), '[]'
    ) as ingredients
from patient r
left join doctor_to_patient ir on r.id = ir.patient_id
left join doctor i on i.id = ir.doctor_id
group by r.id;
