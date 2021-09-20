USE example

-- Тема Операции, задание 1
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными.
-- Заполните их текущими датой и временем.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', NULL, NULL),
  ('Наталья', '1984-11-12', NULL, NULL),
  ('Александр', '1985-05-20', NULL, NULL),
  ('Сергей', '1988-02-14', NULL, NULL),
  ('Иван', '1998-01-12', NULL, NULL),
  ('Мария', '2006-08-29', NULL, NULL);

SELECT * FROM users 

UPDATE users SET created_at = NOW(); -- поле заполнено текущей датой и временем
UPDATE users SET updated_at = NOW(); -- поле заполнено текущей датой и временем

-- Тема Операции, задание 2
-- Таблица users была неудачно спроектирована.
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались
-- значения в формате "20.10.2017 8:10".
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');
 
UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'); -- строчное значение с типом VARCHAR заменено датой 
UPDATE users SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i'); -- строчное значение с типом VARCHAR заменено датой
ALTER TABLE users MODIFY COLUMN created_at DATETIME; -- изменен тип данных всего столбца с VARCHAR на DATETIME
ALTER TABLE users MODIFY COLUMN updated_at DATETIME; -- изменен тип данных всего столбца с VARCHAR на DATETIME

DESCRIBE users 

-- Тема Операции, задание 3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые
-- разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения
-- значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);

SELECT * FROM storehouses_products ORDER BY value = 0, value -- сортировка по условиям задания

-- Тема Операции, задание 4
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в
-- августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT name, birthday_at FROM users 
       WHERE monthname(birthday_at) = 'may' 
       OR monthname(birthday_at) = 'august' -- выборка всех пользователей с нужным месяцем рождения
       
-- Тема Операции, задание 5
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2);
-- Отсортируйте записи в порядке, заданном в списке IN.

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
) COMMENT = 'Каталог';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 
SELECT * FROM catalogs WHERE id IN (5, 1, 2) 
         ORDER BY FIELD(id, 5, 1, 2) -- сортировка полученных значений из поля в заданном порядке

-- Тема Агрегация, задание 1
-- Подсчитайте средний возраст пользователей в таблице users

SELECT ROUND(AVG((YEAR(current_date()) - YEAR (birthday_at))-(RIGHT (CURRENT_DATE, 5)<RIGHT(birthday_at, 5))), 0) AS average_age FROM users; -- средний возраст в таблице users = 29 лет

-- Тема Агрегация, задание 2
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT DAYNAME(CONCAT(YEAR(current_date), RIGHT(birthday_at, 6))) AS day_name, -- обозначаем дату рождения в текущем году
       COUNT(*) AS Day_Quantity -- ведем подсчет количества строк
       FROM users GROUP BY day_name; -- группируем по названиям дней недели

-- Тема Агрегация, задание 3
-- (по желанию) Подсчитайте произведение чисел в столбце таблицы
-- Используйте таблицу catalogs, созданную для задания 5 темы Операции
       
 SELECT EXP(sum(ln(id))) FROM catalogs WHERE id IN (5, 1, 2)      
       
       
