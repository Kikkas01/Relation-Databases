-- задачи 6-го урока здесь необходимо решить с помощью JOIN

USE vk

SELECT * FROM messages WHERE from_user_id = 96 OR to_user_id = 96

-- немного модифицировал данные:
UPDATE messages SET from_user_id = 87 WHERE from_user_id IN (85, 57) AND to_user_id = 96
UPDATE messages SET to_user_id = 15 WHERE to_user_id IN (79, 23) AND from_user_id = 96
UPDATE messages SET to_user_id = 87 WHERE to_user_id = 100 AND from_user_id = 96
/*Итого в таблице сообщений получилось 2 сообщения от 96 к 15, 1 сообщение от 96 к 87, 
  3 сообщения от 87 к 96, 1 сообщение от 8 к 96 и 1 сообщение от 15 к 96 */


SELECT * FROM friendship WHERE user_id = 96 OR friend_id = 96
SELECT * FROM friendship_request_types
UPDATE friendship SET request_type_id = 1 WHERE user_id = 96 OR friend_id = 96
UPDATE friendship SET user_id = 8 WHERE friend_id = 96
UPDATE friendship SET friend_id = 87 WHERE friend_id = 37 AND user_id = 96
UPDATE friendship SET friend_id = 15 WHERE friend_id = 68 AND user_id = 96
-- итого у пользователя 96 получилось три друга - 8,15 и 87

/*Пункт задания 1. Пусть задан некоторый пользователь. Задаю пользователя №96
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
Критерий дружбы для задания - тип запроса с любой из сторон должен быть 1
Кто больше всего общался с пользователем = тот, с кем наибольшее количество ВЗАИМНО отправленных сообщений */

WITH friends AS 
(SELECT 
CASE 
WHEN friend_id = 96 THEN user_id 
WHEN user_id = 96 THEN friend_id
END friends_96
FROM 
friendship 
WHERE user_id = 96 OR friend_id = 96 AND request_type_id = 1 AND confirmed_at IS NOT NULL) 


SELECT f.friends_96, count(1) AS message_count FROM friends f 
LEFT JOIN messages m 
ON
f.friends_96 = m.from_user_id 
AND 
m.to_user_id = 96
OR
f.friends_96 = m.to_user_id 
AND 
m.from_user_id = 96
GROUP BY f.friends_96
ORDER BY f.friends_96 DESC 
LIMIT 1

-- в результирующей таблице мы снова видим какому другу чаще всего писал наш №96, и от какого друга чаще всего приходили сообщения №96

/* Пункт задания 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. */

-- Решение:
WITH user_age AS (
SELECT id, first_name, last_name, (YEAR(current_date()) - YEAR (birthday))-(RIGHT (CURRENT_DATE, 5)<RIGHT(birthday, 5)) AS age 
FROM users
),
likes_1 AS (SELECT count(1) AS likes_quantity FROM user_age u 
LEFT JOIN 
likes l 
ON 
u.id = l.post_id  
OR 
u.id = l.media_id 
OR 
u.id = l.profile_id  

WHERE l.post_id IS NOT NULL OR l.media_id IS NOT NULL OR l.profile_id IS NOT NULL
GROUP BY u.id
ORDER BY u.age
LIMIT 10)

SELECT sum(likes_quantity) FROM likes_1

-- в 6м задании посчитал неверно, т.к. запрос не учитывал тех молодых пользователей, у которых вообще не оказалось лайков
-- в этом задании поправил это, запрос выдаёт одно число 29

/* Пункт задания 3. Определить кто больше поставил лайков (всего) - мужчины или женщины? */

SELECT u.gender, count(1) FROM users u 
INNER JOIN 
likes l 
ON 
u.id = l.user_id   
GROUP BY u.gender 

-- Результат совпал с заданием 6, M - 50, F - 48 лайков соответственно. 



