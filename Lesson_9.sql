-- Задания по блоку 1 (Транзакции и представления)

/* 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции */
 
START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;

SELECT * FROM shop.users 
SELECT * FROM sample.users 

/* 2. Создайте представление, которое выводит название name товарной позиции из таблицы products 
 и соответствующее название каталога name из таблицы catalogs. */

CREATE VIEW name AS
SELECT p.name AS prod_name, c.name AS cat_name FROM products p 
LEFT JOIN catalogs c ON 
p.catalog_id = c.id 

SELECT * FROM name; 

/* 3. (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые 
 календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
 Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
 если дата присутствует в исходном таблице и 0, если она отсутствует. */

-- подготавливаем таблицы:
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  user_id INT,
  total DECIMAL (11,2) COMMENT 'Счет',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Счета пользователей и интернет магазина';

INSERT INTO accounts (user_id, total) VALUES
  (4, 5000.00),
  (3, 0.00),
  (2, 200.00),
  (NULL, 25000.00);

UPDATE accounts SET created_at = '2018-08-01' WHERE id = 1;
UPDATE accounts SET created_at = '2018-08-04' WHERE id = 2;
UPDATE accounts SET created_at = '2018-08-16' WHERE id = 3;
UPDATE accounts SET created_at = '2018-08-17' WHERE id = 4;
 
CREATE TABLE august 
(
anything INT 
);
INSERT INTO august VALUES (FLOOR(1 + RAND() * 31))  -- вставляем 31 (или более) раз произвольную строку

-- решение:
WITH t1 AS (
SELECT DATE_ADD('2018-08-01', INTERVAL Days DAY) AS `day` 
       FROM (SELECT @d:=0 AS Days
             UNION
             SELECT @d:=@d+1 AS Days from august -- вместо таблицы august можно взять любую, где будет более 31 записи
             LIMIT 0, 31) AS august_days) 
SELECT `day`, NOT ISNULL (created_at) AS exist FROM t1
LEFT JOIN accounts a ON t1.`day` = a.created_at 

/* 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
 Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей. */

-- увеличим количество строк в таблице accounts для проверки 

INSERT INTO accounts (user_id, total) VALUES
  (8, 4000.00),
  (9, 1.00),
  (10, 300.00);
  
SELECT * FROM accounts
ORDER BY created_at 

-- решение:
START TRANSACTION;
PREPARE acc_delete FROM 'DELETE FROM accounts ORDER BY created_at LIMIT ?';
SET @del_quantity = (SELECT count(1) - 5 FROM accounts);
EXECUTE acc_delete USING @del_quantity;
COMMIT; 

-- Задания по блоку 3 (процедуры и функции)

/* 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
 С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу 
 "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

/* 
 Изначально пробовал так:
 
DELIMITER // 
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello ()
RETURNS VARCHAR (100) NOT DETERMINISTIC 
BEGIN 
  CASE 
  WHEN CURRENT_TIME() BETWEEN '06:00:00' AND '12:00:00'
  THEN RETURN 'Доброе утро';
  WHEN CURRENT_TIME() BETWEEN '12:00:00' AND '18:00:00'
  THEN RETURN 'Добрый день';
  WHEN CURRENT_TIME() BETWEEN '18:00:00' AND '00:00:00'
  THEN RETURN 'Добрый вечер';
  ELSE RETURN 'Доброй ночи';
END CASE;
END//

Такой вариант отказался работать, хотя по идее ДОЛЖЕН, потому что в обычном селекте прекрасно работает, например: 

SELECT 
CASE 
	WHEN CURRENT_TIME() BETWEEN '06:00:00' AND '12:00:00'
	THEN 'Доброе утро'
	ELSE 'Доброе что угодно'
	END 
выдаёт четкий результат
так и не понял, почему не работает с функцией CURRENT_TIME(), пришлось брать HOUR(NOW()) вместо неё 
И еще пришлось задать сначала SET GLOBAL log_bin_trust_function_creators = 1, без этого функция даже в консоли не создавалась*/

-- Решение:

DELIMITER // 
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello ()
RETURNS VARCHAR (100) NOT DETERMINISTIC 
BEGIN 
	CASE 
	WHEN HOUR(NOW()) BETWEEN '6' AND '12'	
	THEN RETURN 'Доброе утро';
	WHEN HOUR(NOW()) BETWEEN '12' AND '18'	
	THEN RETURN 'Добрый день';
	WHEN HOUR(NOW()) BETWEEN '18' AND '0'	
	THEN RETURN 'Добрый вечер';
	ELSE RETURN 'Доброй ночи';
END CASE;
END//

SELECT hello ()

/* 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное 
 значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

SELECT * FROM products p 

-- решение
-- почему-то триггеры и функции ни разу не получилось создать через DBeaver, только через консоль... 
-- В бобре постоянно непонятная ругань на синтаксис без указания конкретной фразы. 
-- Абсолютно тот же синтаксис в консоли срабатывает ок. 

DELIMITER //
CREATE TRIGGER descr_name_not_null_insert 
BEFORE INSERT ON products
FOR EACH ROW BEGIN 
IF NEW.name IS NULL AND NEW.description IS NULL 
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Name and description are both NULL. Operation is cancelled";
END IF; 
END// 

CREATE TRIGGER descr_name_not_null_update 
BEFORE UPDATE ON products
FOR EACH ROW BEGIN 
IF NEW.name IS NULL AND NEW.description IS NULL 
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Имя и описание не могут быть одновременно нулевыми. Операция отменена";
END IF; 
END// 

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 8000.00, 1)






