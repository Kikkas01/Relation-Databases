USE telegram

-- Запросы:
-- 1. Найти самый популярный канал (с наибольшим числом подписчиков)

SELECT channel_id, count(1) AS q FROM channels_subscribers cs 
GROUP BY channel_id 
ORDER BY q DESC 
LIMIT 1

/*2. Найти пользователя, создавшего наибольшее количество каналов и групп
так как каналы создаются от имени пользователя, а группы от имени аккаунта - нужно 
сначала определить, от какого юзера аккаунты в таблице групп. А потом уже считать все это вместе 
с каналами*/

WITH g AS (
SELECT c.user_id, count(1) AS quantity FROM channels c 
GROUP BY c.user_id
UNION SELECT a.user_id, count(1) AS c FROM groups_ g
LEFT JOIN accounts a 
ON 
g.account_id = a.id 
GROUP BY user_id) 
SELECT user_id, sum(quantity) AS summ FROM g 
GROUP BY user_id
ORDER BY summ DESC 
LIMIT 1

-- 3. Найти стикер, который чаще всего использовался в сообщениях - индивидуальных и групповых

WITH stick AS (
SELECT tm.sticker_id, count(1) AS c FROM text_messages tm
WHERE tm.sticker_id IS NOT NULL
GROUP BY tm.sticker_id
UNION 
SELECT gm.sticker_id, count(1) AS c2 FROM group_messages gm 
WHERE gm.sticker_id IS NOT NULL
GROUP BY gm.sticker_id)
SELECT sticker_id, sum(c) AS s FROM stick 
GROUP BY sticker_id
ORDER BY s DESC 
LIMIT 1

-- 4. Найти пару пользователей, которые больше всего общались друг с другом (написали друг другу больше всего сообщений)

SELECT concat (from_account_id, '-', to_account_id) AS pair, count(1) AS c FROM text_messages
GROUP BY (from_account_id+to_account_id),(from_account_id*to_account_id)
ORDER BY c DESC 
LIMIT 1

-- 5. Определить, кто чаще посылает текстовые сообщения со стикерами - мужчины или женщины
-- сначала нужно определить пол аккаунта через юзера, далее уже вести подсчёт 


SELECT gender, count(1) AS c FROM text_messages tm 
LEFT JOIN accounts a ON tm.from_account_id = a.id
LEFT JOIN users u ON a.user_id = u.id
GROUP BY gender

-- Представления:
-- 1. Представление, которое выводит название канала и имя его создателя

CREATE VIEW channel_creator AS
SELECT c.name AS channel_name, u.name AS user_name FROM channels c 
LEFT JOIN users u ON 
c.user_id = u.id

SELECT * FROM channel_creator

-- 2. Представление, отображающее гендерный состав групп

CREATE VIEW group_gender AS
SELECT g.name AS group_name, u.gender AS gender, count(1) AS quantity FROM group_members gm
LEFT JOIN groups_ g ON 
gm.group_id = g.id
LEFT JOIN accounts a ON 
gm.account_id = a.id
LEFT JOIN users u ON 
a.user_id = u.id
WHERE u.gender = 'M'
GROUP BY g.name
UNION ALL 
SELECT g.name AS group_name, u.gender AS gender, count(1) AS quantity FROM group_members gm
LEFT JOIN groups_ g ON 
gm.group_id = g.id
LEFT JOIN accounts a ON 
gm.account_id = a.id
LEFT JOIN users u ON 
a.user_id = u.id
WHERE u.gender = 'F'
GROUP BY g.name
ORDER BY group_name

SELECT * FROM group_gender

-- Хранимые процедуры:
-- 1. Процедура, позволяющая выводить заданное число каналов с наибольшим количеством пользователей (top-'var')

DELIMITER //
DROP PROCEDURE IF EXISTS channels_chart//
CREATE PROCEDURE channels_chart (IN var INT)
BEGIN
SELECT channel_id, count(1) AS q FROM channels_subscribers cs 
GROUP BY channel_id 
ORDER BY q DESC 
LIMIT var;	
END//
DELIMITER ;

CALL channels_chart(5)

-- 2. Процедура, выводящая количество юзеров мужского и женского пола, в соответствии с входным параметром

DELIMITER //
DROP PROCEDURE IF EXISTS gender_count//
CREATE PROCEDURE gender_count (INOUT gender_q INT, IN var1 CHAR(1))
BEGIN
SELECT count(1) INTO gender_q FROM users
WHERE var1 = gender;	
END//
DELIMITER ;

CALL gender_count (@c, 'M')
SELECT @c


-- Триггер: при вставке значения в поле sticker_id в таблицу сообщений - идет проверка, что поля body и attachment_id при этом оба нулевые. 

DELIMITER //
DROP TRIGGER IF EXISTS sticker_notnull// 
CREATE TRIGGER sticker_notnull 
BEFORE INSERT ON text_messages
FOR EACH ROW 
BEGIN 
	IF NEW.sticker_id IS NOT NULL AND NEW.body IS NOT NULL 
	OR NEW.attachment_id IS NOT NULL
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "You can't use stickers with text or attachment";
END IF; 
END// 
DELIMITER ;

INSERT INTO text_messages (from_account_id, to_account_id, body, attachment_id, sticker_id) VALUES ('1', '2', 'slkdfj;lasdkjfjjf', NULL, '2')
INSERT INTO text_messages (from_account_id, to_account_id, body, attachment_id, sticker_id) VALUES ('1', '2', NULL, '3', '2')
INSERT INTO text_messages (from_account_id, to_account_id, body, attachment_id, sticker_id) VALUES ('1', '2', NULL, NULL, '2')



