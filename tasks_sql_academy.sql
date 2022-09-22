"№1 Вывести имена всех когда-либо обслуживаемых пассажиров авиакомпаний."
SELECT name 
FROM Passenger
"№2 Вывести названия всеx авиакомпаний."
SELECT name
FROM Company
"№3 Вывести все рейсы, совершенные из Москвы."
SELECT *
FROM Trip
WHERE town_from = 'Moscow';
"№4 Вывести имена людей, которые заканчиваются на "man"."
SELECT name
FROM Passenger
WHERE name LIKE '%man'
"№5 Вывести количество рейсов, совершенных на TU-134."
SELECT COUNT(*) AS count  
FROM Trip  
WHERE plane = 'TU-134';
"№6 Какие компании совершали перелеты на Boeing."
SELECT DISTINCT name
FROM Company
INNER JOIN Trip ON Company.id=Trip.company
WHERE plane='Boeing';
"№7 Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)."
SELECT DISTINCT plane
FROM Trip
WHERE town_from='Moscow';
"№8 В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?"
SELECT town_to, TIMEDIFF(time_in, time_out) AS flight_time
FROM Trip
WHERE town_from='Paris';
"№9 Какие компании организуют перелеты с Владивостока (Vladivostok)?"
SELECT name
FROM Company  
INNER JOIN Trip ON Company.id=Trip.company
WHERE town_from='Vladivostok';
"№10 Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г."
SELECT *
FROM Trip
WHERE time_out BETWEEN '1900-01-01:10:00.00' AND '1900-01-01:14:00.00';
"№11 Вывести пассажиров с самым длинным именем."
SELECT name
FROM Passenger 
WHERE LENGTH(name)=(SELECT MAX(LENGTH(name)) FROM Trip)
ORDER BY LENGTH(name) DESC LIMIT 1;
"№12 Вывести id и количество пассажиров для всех прошедших полётов."
SELECT trip, COUNT(passenger) AS count
FROM Pass_in_trip 
GROUP BY trip;
"№13 Вывести имена людей, у которых есть полный тёзка среди пассажиров."
SELECT name
FROM Passenger 
GROUP BY name
HAVING COUNT(name) > 1;
"№14 В какие города летал Bruce Willis."
SELECT town_to
FROM Trip
INNER JOIN Pass_in_trip ON Pass_in_trip.trip = Trip.id
INNER JOIN Passenger ON Passenger.id = Pass_in_trip.passenger
WHERE Passenger.name='Bruce Willis';
"№15 Во сколько Стив Мартин (Steve Martin) прилетел в Лондон (London)."
SELECT time_in
FROM Trip
INNER JOIN Pass_in_trip ON Pass_in_trip.trip = Trip.id
INNER JOIN Passenger ON Passenger.id = Pass_in_trip.passenger
WHERE Passenger.name='Steve Martin' AND town_to='London';
"№16 Вывести отсортированный по количеству перелетов (по убыванию) и имени
(по возрастанию) список пассажиров, совершивших хотя бы 1 полет."
SELECT name, COUNT(trip) AS count  
FROM Passenger  
INNER JOIN Pass_in_trip ON Passenger.id=Pass_in_trip.passenger
GROUP BY name
ORDER BY count DESC, name ASC;
"№17 Определить, сколько потратил в 2005 году каждый из членов семьи."
SELECT member_name, status, SUM(amount*unit_price) AS costs
FROM FamilyMembers
INNER JOIN Payments ON FamilyMembers.member_id=Payments.family_member
WHERE YEAR(date) = 2005
GROUP BY member_name, status;
"№18 Узнать, кто старше всех в семьe."
SELECT member_name
FROM FamilyMembers
WHERE birthday = (SELECT MIN(birthday) FROM FamilyMembers);
"№19 Определить, кто из членов семьи покупал картошку (potato)."
SELECT DISTINCT status
FROM FamilyMembers
INNER JOIN Payments
  ON Payments.family_member = FamilyMembers.member_id
INNER JOIN Goods
  ON Payments.good = Goods.good_id
WHERE Goods.good_name='potato';
"№20 Сколько и кто из семьи потратил на развлечения (entertainment).
Вывести статус в семье, имя, сумму."
SELECT status, member_name, SUM(Payments.amount*Payments.unit_price) AS costs
FROM FamilyMembers
INNER JOIN Payments
  ON FamilyMembers.member_id=Payments.family_member
INNER JOIN Goods
  ON Payments.good=Goods.good_id
INNER JOIN GoodTypes
  ON Goods.type=GoodTypes.good_type_id 
WHERE GoodTypes.good_type_name='entertainment'
GROUP BY FamilyMembers.status, FamilyMembers.member_name;
"№21 Определить товары, которые покупали более 1 раза."
SELECT good_name
FROM Goods
INNER JOIN Payments ON Goods.good_id = Payments.good
GROUP BY good
HAVING COUNT(Payments.good) > 1;
"№22 Найти имена всех матерей (mother)."
SELECT member_name
FROM FamilyMembers
WHERE status='mother';
"№23 Найдите самый дорогой деликатес (delicacies) и выведите его стоимость."
SELECT good_name, MAX(unit_price) AS unit_price
FROM Goods
INNER JOIN Payments
  ON Payments.good = Goods.good_id
INNER JOIN GoodTypes
  ON GoodTypes.good_type_id = Goods.type
WHERE good_type_name='delicacies'
GROUP BY good
LIMIT 1
"№24 Определить кто и сколько потратил в июне 2005."
SELECT member_name, SUM(amount*unit_price) AS costs
FROM FamilyMembers
INNER JOIN Payments
  ON FamilyMembers.member_id=Payments.family_member
WHERE MONTH(date)=06 AND YEAR(date)=2005
GROUP BY member_name;
"№25 Определить, какие товары не покупались в 2005 году."
SELECT good_name
FROM Goods
WHERE good_id NOT IN (SELECT good FROM Payments
                      WHERE YEAR(date)=2005);
"№26 Определить группы товаров, которые не приобретались в 2005 году."
SELECT good_type_name 
FROM GoodTypes
WHERE good_type_id NOT IN (
  SELECT good_type_id 
  FROM GoodTypes
  INNER JOIN Goods ON 
    GoodTypes.good_type_id=Goods.type
  INNER JOIN Payments ON 
    Goods.good_id=Payments.good
  WHERE YEAR(date)=2005);
"№27 Узнать, сколько потрачено на каждую из групп товаров в 2005 году.
Вывести название группы и сумму"
SELECT good_type_name, SUM(amount*unit_price) AS costs
FROM GoodTypes
INNER JOIN Goods ON GoodTypes.good_type_id=Goods.type
INNER JOIN Payments ON Goods.good_id=Payments.good
WHERE YEAR(Payments.date)=2005
GROUP BY good_type_name;
"№28 Сколько рейсов совершили авиакомпании с Ростова (Rostov) в Москву (Moscow)?"
SELECT COUNT(*) AS count
FROM Trip
WHERE town_from='Rostov' AND town_to='Moscow';
"№29 Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134."
SELECT DISTINCT name
FROM Passenger
INNER JOIN Pass_in_trip 
  ON Passenger.id=Pass_in_trip.passenger
INNER JOIN Trip
  ON Trip.id=Pass_in_trip.trip
WHERE plane='TU-134' AND town_to='Moscow';
"№30 Выведите нагруженность (число пассажиров) каждого рейса (trip).
Результат вывести в отсортированном виде по убыванию нагруженности."
SELECT trip, COUNT(Passenger) AS count
FROM Pass_in_trip
GROUP BY trip
ORDER BY count DESC;
"№31 Вывести всех членов семьи с фамилией Quincey."
SELECT *
FROM FamilyMembers
WHERE member_name LIKE '%Quincey';
"№32 Вывести средний возраст людей (в годах), хранящихся в базе данных.
Результат округлите до целого в меньшую сторону."
SELECT FLOOR(AVG(YEAR(CURRENT_DATE)-YEAR(birthday))) AS age
FROM FamilyMembers;
"№33 Найдите среднюю стоимость икры.
В базе данных хранятся данные о покупках красной (red caviar)
и черной икры (black caviar)."
SELECT AVG(unit_price) AS cost
FROM Payments
WHERE good IN (
  SELECT good_id
  FROM Goods
  WHERE good_name LIKE '%caviar');
"№34 Сколько всего 10-ых классов"
SELECT COUNT(name) AS count
FROM Class 
WHERE name LIKE '10%';
"№35 Сколько различных кабинетов школы
использовались 2.09.2019 в образовательных целях ?"
SELECT COUNT(classroom) AS count
FROM Schedule
WHERE date='2019-09-2';
"№36 Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?"
SELECT *
FROM Student
WHERE address LIKE 'ul. Pushkina%';
"№37 Сколько лет самому молодому обучающемуся ?"
SELECT MIN(TIMESTAMPDIFF(YEAR, birthday, CURRENT_DATE)) AS year
FROM Student;
"№38 Сколько Анн (Anna) учится в школе ?"
SELECT COUNT(*) AS COUNT
FROM Student
WHERE first_name='Anna'
"№39 Сколько обучающихся в 10 B классе ?"
SELECT COUNT(*) AS count
FROM Student_in_class
INNER JOIN Class ON Student_in_class.class = Class.id
WHERE name = '10 B';
"№40 Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.) ?"
SELECT name AS subjects
FROM Subject
INNER JOIN Schedule ON Subject.id = Schedule.subject
INNER JOIN Teacher ON Teacher.id = Schedule.teacher
WHERE Teacher.last_name = 'Romashkin'
      AND Teacher.first_name LIKE 'P%'
      AND Teacher.middle_name LIKE 'P%';
"№41 Во сколько начинается 4-ый учебный предмет по расписанию ?"
SELECT start_pair
FROM Timepair
WHERE id = 4;
"№42 Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет ?"
SELECT DISTINCT TIMEDIFF(
  (SELECT end_pair FROM Timepair WHERE id=4),
  (SELECT start_pair FROM Timepair WHERE id=2)) AS time
FROM Timepair;
"№43 Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture).
Отcортируйте преподавателей по фамилии."
SELECT DISTINCT last_name
FROM Teacher
INNER JOIN Schedule
  ON Teacher.id = Schedule.teacher
INNER JOIN Subject
  ON Schedule.subject = Subject.id
WHERE Subject.name = 'Physical Culture'
ORDER BY Teacher.last_name;
"№44 Найдите максимальный возраст (колич. лет) среди обучающихся 10 классов?"
SELECT (YEAR(NOW())-MIN(YEAR(birthday))) AS max_year
FROM Student
INNER JOIN Student_in_class 
  ON Student.id = Student_in_class.student
INNER JOIN Class
  ON Class.id = Student_in_class.class
WHERE Class.name LIKE '10%';
"№45 Какой(ие) кабинет(ы) пользуются самым большим спросом?"
SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(classroom) = (
  SELECT COUNT(classroom)
  FROM Schedule
  GROUP BY classroom 
  ORDER BY classroom DESC
  LIMIT 1
  );
"№46 В каких классах введет занятия преподаватель "Krauze" ?"
SELECT DISTINCT name
FROM Class
INNER JOIN Schedule 
  ON Schedule.class = Class.id
INNER JOIN teacher
  ON Schedule.teacher = Teacher.id
WHERE Teacher.last_name = 'Krauze';
"№47 Сколько занятий провел Krauze 30 августа 2019 г.?"
SELECT COUNT(teacher) As count
FROM Schedule
WHERE date = '2019-08-30' AND teacher IN (
  SELECT id
  FROM Teacher
  WHERE last_name = 'Krauze');
"№48 Выведите заполненность классов в порядке убывания"
SELECT name, COUNT(student) AS count
FROM Class
INNER JOIN Student_in_class
  ON Class.id = Student_in_class.class
GROUP BY name
ORDER BY count DESC;
"№49 Какой процент обучающихся учится в 10 A классе?"
SELECT (COUNT(*)*100/(SELECT COUNT(Student.id) as count 
                      FROM Student
                      JOIN Student_in_class
                      ON Student.id=Student_in_class.student)) AS percent 
FROM Student_in_class
JOIN Class
  ON Class.id=Student_in_class.class AND name = '10 A';
"№50 Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону."
SELECT FLOOR(COUNT(*)*100/(SELECT COUNT(*) FROM Student)) AS percent
FROM Student
WHERE YEAR(birthday) = '2000';
"№51 Добавьте товар с именем "Cheese" и типом "food" в список товаров (Goods)."
INSERT INTO Goods
SET good_id=(SELECT COUNT(*)+1 FROM Goods AS a),
    good_name="Cheese",
    type=(SELECT good_type_id
          FROM GoodTypes
          WHERE good_type_name = 'food');
"№52 Добавьте в список типов товаров (GoodTypes) новый тип "auto"."
INSERT INTO GoodTypes
SELECT COUNT(*)+1, 'auto'
FROM GoodTypes;
"№53 Измените имя "Andie Quincey" на новое "Andie Anthony"."
UPDATE FamilyMembers
SET member_name = 'Andie Anthony'
WHERE member_name = 'Andie Quincey';
"№54 Удалить всех членов семьи с фамилией "Quincey"."
DELETE FROM FamilyMembers
WHERE member_name LIKE '%Quincey';
"№55 Удалить компании, совершившие наименьшее количество рейсов."
SELECT name, COUNT(company) as company
FROM Trip JOIN Company ON Company.id=Trip.company
GROUP BY name;
DELETE FROM Company WHERE id = 4;
DELETE FROM Company WHERE id = 3;
DELETE FROM Company WHERE id = 2;
"№56 Удалить все перелеты, совершенные из Москвы (Moscow)."
DELETE FROM Trip
WHERE town_from = 'Moscow';
"№57 Перенести расписание всех занятий на 30 мин. вперед."
UPDATE Timepair
SET start_pair = start_pair + INTERVAL 30 MINUTE,
    end_pair = end_pair + INTERVAL 30 MINUTE;
"№58 Добавить отзыв с рейтингом 5 на жилье, находящиеся по адресу "11218,
Friel Place, New York", от имени "George Clooney""
SELECT Users.name, Reservations.* 
FROM Reservations 
JOIN Rooms
ON Rooms.id=Reservations.room_id
JOIN Users
ON Users.id=Reservations.user_id
WHERE address = '11218, Friel Place, New York';
INSERT INTO Reviews (id, reservation_id, rating) VALUES (23, 2, 5);
"№59 Вывести пользователей,указавших Белорусский номер телефона ? Телефонный код Белоруссии +375."
SELECT *
FROM Users
WHERE phone_number LIKE '+375%';
"№60 Выведите идентификаторы преподавателей, которые хотя бы один раз за всё время преподавали в каждом из одиннадцатых классов."
SELECT teacher 
FROM Schedule
INNER JOIN Class ON Schedule.class=Class.id 
WHERE Class.name LIKE '11%'
GROUP BY teacher
HAVING COUNT(DISTINCT Class.name) = 2;
"№61 Выведите список комнат, которые были зарезервированы в течение 12 недели 2020 года."
SELECT Rooms.*
FROM Rooms
JOIN Reservations 
  ON Rooms.id=Reservations.room_id AND YEAR(start_date)=2020 AND YEAR(end_date)=2020
WHERE WEEK(start_date, 1)=12 OR WEEK(end_date, 1)=12;
"№62 Вывести в порядке убывания популярности доменные имена 2-го уровня, используемые пользователями для электронной почты.
Полученный результат необходимо дополнительно отсортировать по возрастанию названий доменных имён. "
SELECT SUBSTRING_INDEX(email, '@', -1) as domain,
      count(*) AS count
FROM Users GROUP BY domain
ORDER BY count DESC, domain ASC;
"№63 Выведите отсортированный список (по возрастанию) имен студентов в виде Фамилия.И.О."
SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.', LEFT(middle_name, 1), '.') AS name
FROM Student
ORDER BY name;
"№64 Вывести количество бронирований по каждому месяцу каждого года, в которых было хотя бы 1 бронирование.
Результат отсортируйте в порядке возрастания даты бронирования."
"№65 Необходимо вывести рейтинг для комнат, которые хоть раз арендовали, как среднее значение рейтинга отзывов округленное до целого вниз.
"
SELECT room_id, FLOOR(AVG(rating)) AS rating
FROM Reservations
INNER JOIN Reviews ON Reviews.reservation_id = Reservations.id 
GROUP BY room_id;
"№66 Вывести список комнат со всеми удобствами (наличие ТВ, интернета, кухни и кондиционера),
а также общее количество дней и сумму за все дни аренды каждой из таких комнат."
SELECT home_type, address, IFNULL(SUM(TIMESTAMPDIFF(DAY, start_date, end_date)), 0) AS days,
       IFNULL(SUM(total), 0) AS total_fee
FROM Rooms
LEFT JOIN Reservations ON Rooms.id=Reservations.room_id
WHERE (has_tv, has_internet, has_kitchen, has_air_con) = (1, 1, 1, 1)
GROUP BY Rooms.id;
"№67 Вывести время отлета и время прилета для каждого перелета в формате "ЧЧ:ММ, ДД.ММ - ЧЧ:ММ, ДД.ММ",
где часы и минуты с ведущим нулем, а день и месяц без."
SELECT CONCAT(
  (LPAD((HOUR(time_out)), 2, '0')), ':', (LPAD((MINUTE(time_out)), 2, '0')), ', ',(DAY(SUBSTRING(time_out, 1, 10))), '.',(MONTH(SUBSTRING(time_in, 1, 10))), ' - ',
  (LPAD((HOUR(time_in)), 2, '0')), ':', (LPAD((MINUTE(time_in)), 2, '0')), ', ',(DAY(SUBSTRING(time_in, 1, 10))), '.',(MONTH(SUBSTRING(time_in, 1, 10)))
  ) AS flight_time
FROM Trip;
"№68 Для каждой комнаты, которую снимали как минимум 1 раз, найдите имя человека,
снимавшего ее последний раз, и дату, когда он выехал"
WITH get_data AS (
SELECT room_id,
MAX(end_date) as end_date
FROM Reservations
GROUP BY room_id
HAVING COUNT(*) >= 1
)
SELECT Reservations.room_id,
Users.name,
Reservations.end_date
from Reservations
JOIN get_data ON get_data.room_id = Reservations.room_id
and get_data.end_date = Reservations.end_date
JOIN Users ON Users.id = Reservations.user_id;
"№69 Вывести идентификаторы всех владельцев комнат,
что размещены на сервисе бронирования жилья и сумму, которую они заработали"
SELECT
  Rooms.owner_id AS owner_id, SUM(total) AS total_earn
FROM Reservations
JOIN Rooms
ON Reservations.room_id = Rooms.id
GROUP BY owner_id;
"№70 Необходимо категоризовать жилье на economy, comfort, premium по цене соответственно <= 100, 100 < цена < 200, >= 200.
В качестве результата вывести таблицу с названием категории и количеством жилья, попадающего в данную категорию"
SELECT
  category, COUNT(*) AS count
FROM
  (
    SELECT 
      CASE
        WHEN price <= 100 THEN 'economy'
        WHEN price > 100 AND price < 200 THEN 'comfort'
        ELSE 'premium'
      END AS category
    FROM Rooms
  ) AS cat
GROUP BY 1;
"№71 "