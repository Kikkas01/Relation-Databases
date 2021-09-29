USE sample

SELECT * FROM users  
SELECT * FROM orders  

-- Задание 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT name FROM users WHERE id IN (SELECT user_id FROM orders)

-- Задание 2. Выведите список товаров products и разделов catalogs, который соответствует товару

SELECT p.id, p.name, c.name FROM products AS p 
LEFT JOIN 
catalogs AS c 
ON p.catalog_id = c.id 

/*Задание 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) 
  и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, 
  поле name — русское. Выведите список рейсов flights с русскими названиями городов.*/

CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'Английское название города вылета',
  `to` VARCHAR(255) COMMENT 'Английское название города прилёта'
  ) COMMENT = 'Таблица рейсов';
 
 CREATE TABLE cities (
  label VARCHAR(255) COMMENT 'Английское название города',
  name VARCHAR(255) COMMENT 'Русское название'
  ) COMMENT = 'Таблица городов';
  
 INSERT INTO cities 
 (label, name)
 VALUES 
 ('Moscow', 'Москва'),
 ('St.Petersburg', 'Санкт-Петербург'),
 ('Kaliningrad', 'Калининград'),
 ('Rostov', 'Ростов');

INSERT INTO flights 
 (`from`, `to`)
 VALUES 
 ('Moscow', 'St.Petersburg'),
 ('St.Petersburg', 'Kaliningrad'),
 ('Kaliningrad', 'Rostov');
 
-- скрипт получения наименований городов прилета и отлета по-русски: 
 SELECT f.id, c2.name AS flight_from, c1.name AS flight_to FROM 
 flights AS f 
 LEFT JOIN 
 cities AS c1 ON c1.label = f.`to`
 LEFT JOIN 
 cities AS c2 
 ON c2.label = f.`from` 

 
 