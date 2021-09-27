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

/*Пункт задания 2. Пусть задан некоторый пользователь. Задаю пользователя №96
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
Критерий дружбы для задания - тип запроса с любой из сторон должен быть 1
Кто больше всего общался с пользователем = тот, с кем наибольшее количество ВЗАИМНО отправленных сообщений */
WITH mess AS (
SELECT
	from_user_id,
	to_user_id,
	count(1) AS message_count
FROM
	messages
WHERE
	from_user_id IN (
	SELECT
		user_id
	FROM
		friendship
	WHERE
		friend_id = 96
		AND request_type_id = 1
UNION
	SELECT
		friend_id
	FROM
		friendship
	WHERE
		user_id = 96
		AND request_type_id = 1)
	AND to_user_id = 96
	OR 
to_user_id IN (
	SELECT
		user_id
	FROM
		friendship
	WHERE
		friend_id = 96
		AND request_type_id = 1
UNION
	SELECT
		friend_id
	FROM
		friendship
	WHERE
		user_id = 96
		AND request_type_id = 1)
	AND from_user_id = 96
GROUP BY
	from_user_id,
	to_user_id
ORDER BY
	message_count DESC,
	from_user_id,
	to_user_id
)
SELECT
	(from_user_id + to_user_id) - 96 AS friend,
	sum(message_count) AS messages
FROM
	mess
GROUP BY
	(from_user_id + to_user_id)
ORDER BY
	message_count DESC
LIMIT 1
;
-- в результирующей таблице мы видим какому другу чаще всего писал наш №96, и от какого друга чаще всего приходили сообщения №96
-- определение дружбы между пользователями отражено во вложенных запросах. 

/* Пункт задания 3 Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. */
SELECT * FROM likes 

-- немного модифицировал данные
SELECT id, user_id FROM media
ORDER BY id 
UPDATE media SET
user_id = FLOOR(1 + RAND() * 100);

SELECT id, user_id FROM posts 
ORDER BY id 
UPDATE posts SET
user_id = FLOOR(1 + RAND() * 100);

-- поскольку MySQL не умеет работать с LIMIT во вложенных запросах, придется делать в два этапа:

-- Этап 1: отберем 10 самых молодых
SELECT id 
FROM users 
ORDER BY (YEAR(current_date()) - YEAR (birthday))-(RIGHT (CURRENT_DATE, 5)<RIGHT(birthday, 5))  
LIMIT 10;
-- результат: 100,81,99,31,55,21,4,76,64,94

-- вычислим user_id для всех лайков из таблицы лайков и отберем самых молодых:
WITH all_likes AS (
SELECT user_id FROM media WHERE id IN (
SELECT media_id FROM likes 
)
UNION ALL SELECT user_id FROM posts WHERE id IN (
SELECT post_id FROM likes 
)
UNION ALL SELECT user_id FROM profiles WHERE user_id IN (
SELECT profile_id FROM likes 
))
SELECT count(1) FROM all_likes WHERE user_id IN (100,81,99,31,55,21,4,76,64,94)
; 
-- итого 10 самых молодых пользователей получили по всем типам контента суммарно 22 лайка


/* Пункт задания 4 Определить кто больше поставил лайков (всего) - мужчины или женщины? */
-- определяем количество лайков, поставленных женщинами:
SELECT count(1) AS women FROM likes WHERE user_id IN (
SELECT id FROM users WHERE gender = 'F') 

-- определяем количество лайков, поставленных мужчинами
SELECT count(1) AS men FROM likes WHERE user_id IN (
SELECT id FROM users WHERE gender = 'M')

-- получилось 48 и 50 лайков соответственно. То есть суммарно больше лайков поставили мужчины. 
-- можно объединить запросы через UNION, но в таком случае результаты получаются друг под другом под заголовком от первого запроса
-- как это решить - не знаю. 

/* Пункт задания 5 Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети 
   Критерий: наименьшая активность в использовании соц. сети = пользователи, от кого поступило наименьшее количество лайков и сообщений */

-- собираю всех пользователей, кто писал лайки и сообщения, и группирую их по сумме активностей
WITH all_likes_mess AS (
SELECT user_id FROM media WHERE id IN (
SELECT media_id FROM likes 
)
UNION ALL 
SELECT user_id FROM posts WHERE id IN (
SELECT post_id FROM likes 
)
UNION ALL 
SELECT user_id FROM profiles WHERE user_id IN (
SELECT profile_id FROM likes
) 
UNION ALL 
SELECT from_user_id AS user_id FROM messages)
SELECT user_id, count(1) AS activity FROM all_likes_mess
GROUP BY user_id 
ORDER BY activity
LIMIT 10;



