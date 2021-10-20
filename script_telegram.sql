
/*БД Телеграм (ограниченный функционал)

Мессенджер, позволяющий обмениваться текстовыми сообщениями, 
с приложением медиаконтента и файлов, а также сообщениями в виде стикеров. 
Есть возможность создавать группы пользователей и информационные каналы. 
*/

DROP DATABASE IF EXISTS telegram;
CREATE DATABASE telegram;

USE telegram;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Имя пользователя в произвольном формате',
    gender ENUM('M', 'F') NOT NULL COMMENT 'Пол',
    main_phone VARCHAR(12) NOT NULL UNIQUE COMMENT 'Основной номер телефона пользователя',    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
  ) COMMENT 'Таблица пользователей, базовые данные юзера при регистрации в системе'; 

ALTER TABLE users ADD CONSTRAINT сheck_phone CHECK (REGEXP_LIKE(main_phone, '^\\+7[0-9]{10}$')) ;

INSERT INTO users (name, gender, main_phone) VALUES ('Ivan Petrov', 'M', '+79216542211');
INSERT INTO users (name, gender, main_phone) VALUES ('Sergey', 'M', '+79212222315');
INSERT INTO users (name, gender, main_phone) VALUES ('Vasilisa Sergeevna', 'F', '+79322356895');
INSERT INTO users (name, gender, main_phone) VALUES ('Trumen', 'M', '+79116589932');
INSERT INTO users (name, gender, main_phone) VALUES ('Sidorov Kassir', 'M', '+79114587962');
INSERT INTO users (name, gender, main_phone) VALUES ('Deloproizvoditel', 'M', '+79216489155');
INSERT INTO users (name, gender, main_phone) VALUES ('Agafia Ivanova', 'F', '+79213658854');
INSERT INTO users (name, gender, main_phone) VALUES ('Zaznoba', 'F', '+79266339632');
INSERT INTO users (name, gender, main_phone) VALUES ('Belaya Goryachka', 'F', '+79253659965');
INSERT INTO users (name, gender, main_phone) VALUES ('Sidorov Vasiliy', 'M', '+79113665489');

SELECT * FROM users  

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL COMMENT 'Связь с таблицей пользователей',
    nickname VARCHAR(100) NOT NULL COMMENT 'Никнейм для аккаунта',
    account_phone VARCHAR(12) NOT NULL UNIQUE COMMENT 'Номер телефона, привязанный к аккаунту, по умолчанию равен main_phone',    
    photo VARCHAR(255) NOT NULL COMMENT 'Ссылка на местоположение файла с фотографией',
    bio TEXT COMMENT 'Описание профиля, необязательное произвольное текстовое поле',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
 ) COMMENT 'Таблица аккаунтов юзеров, у одного юзера может быть несколько аккаунтов'; 

ALTER TABLE accounts ADD CONSTRAINT сheck_account_phone CHECK (REGEXP_LIKE(account_phone, '^\\+7[0-9]{10}$')) ;
ALTER TABLE accounts ADD CONSTRAINT fk_accounts_user_id FOREIGN KEY (user_id) REFERENCES users(id);

INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('1','Petro', '+79216542211', 'https://telegram.net/storage/906.jpeg', 'Аккаунт юзера 1');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('1','Petro2', '+79219653478', 'https://telegram.net/storage/908.jpeg', 'Второй аккаунт юзера 1');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('2','nickname2', '+79212222315', 'https://telegram.net/storage/907.jpeg', 'Аккаунт юзера 2');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('3','nickname3', '+79322356895', 'https://telegram.net/storage/155.jpeg', 'Аккаунт юзера 3');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('4','nickname4', '+79116589932', 'https://telegram.net/storage/156.jpeg', 'Аккаунт юзера 4');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('5','nickname5', '+79114587962', 'https://telegram.net/storage/157.jpeg', 'Аккаунт юзера 5');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('6','nickname6', '+79216489155', 'https://telegram.net/storage/158.jpeg', 'Аккаунт юзера 6');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('7','nickname7', '+79213658854', 'https://telegram.net/storage/159.jpeg', 'Аккаунт юзера 7');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('8','nickname8', '+79266339632', 'https://telegram.net/storage/160.jpeg', NULL);
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('9','nickname9', '+79253659965', 'https://telegram.net/storage/161.jpeg', NULL);
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('10','nickname10', '+79113665489', 'https://telegram.net/storage/162.jpeg', 'Аккаунт юзера 10');
INSERT INTO accounts (user_id, nickname, account_phone, photo, bio) VALUES ('10','nickname10-1', '+79116531187', 'https://telegram.net/storage/163.jpeg', 'Второй аккаунт юзера 10');

SELECT * FROM accounts 

DROP TABLE IF EXISTS sticker_packs;
CREATE TABLE sticker_packs(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
 ) COMMENT 'Таблица стикерпаков'; 

INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('1', 'reiciendis', '1980-05-28 07:07:08', '2005-08-10 09:12:52');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('2', 'facilis', '1973-06-29 07:28:27', '2013-01-07 12:47:20');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('3', 'sequi', '2007-02-18 17:25:47', '2006-09-14 21:52:02');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('4', 'et', '1978-09-04 17:48:55', '1995-02-02 05:17:11');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('5', 'maxime', '1997-02-12 03:19:41', '1994-08-04 15:16:45');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('6', 'magni', '1982-08-07 01:10:26', '2016-12-18 23:35:28');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('7', 'nostrum', '1987-09-18 00:57:02', '1977-11-03 20:40:35');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('8', 'necessitatibus', '2013-01-28 02:02:28', '1991-03-25 06:14:36');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('9', 'a', '1985-04-12 16:28:00', '1977-06-17 09:48:30');
INSERT INTO `sticker_packs` (`id`, `name`, `created_at`, `updated_at`) VALUES ('10', 'officiis', '1992-10-31 08:10:32', '1984-08-30 04:41:35');

DROP TABLE IF EXISTS stickers;
CREATE TABLE stickers(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  file VARCHAR(255) NOT NULL COMMENT 'Ссылка на местоположение файла со стикером',
  sticker_pack_id BIGINT UNSIGNED NOT NULL COMMENT 'Связь с таблицей стикерпаков',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (sticker_pack_id) REFERENCES sticker_packs(id)
 ) COMMENT 'Таблица со стикерами'; 

INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('1', 'debitis', 'https://telegram.net/storage/10.gif', '1', '2000-09-28 07:54:03', '1980-07-24 04:58:08');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('2', 'enim', 'https://telegram.net/storage/20.gif', '1', '2016-04-07 16:42:46', '2013-07-04 04:33:05');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('3', 'blanditiis', 'https://telegram.net/storage/30.gif', '3', '1982-09-16 22:43:01', '2006-12-17 03:08:17');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('4', 'quisquam', 'https://telegram.net/storage/40.gif', '4', '2015-10-09 02:02:58', '2005-12-12 23:50:10');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('5', 'rerum', 'https://telegram.net/storage/50.gif', '3', '1976-09-30 02:33:39', '1988-04-06 05:53:30');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('6', 'veniam', 'https://telegram.net/storage/60.gif', '3', '1989-11-26 05:06:55', '1999-08-28 13:28:08');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('7', 'similique', 'https://telegram.net/storage/70.gif', '7', '2018-04-04 15:32:24', '1986-06-23 08:36:49');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('8', 'sequi', 'https://telegram.net/storage/80.gif', '8', '1977-05-12 06:45:09', '1973-08-06 06:50:10');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('9', 'ab', 'https://telegram.net/storage/90.gif', '9', '2008-03-04 07:44:41', '2020-02-20 15:42:11');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('10', 'et', 'https://telegram.net/storage/100.gif', '10', '2018-04-06 04:46:16', '2011-11-16 06:11:01');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('11', 'provident', 'https://telegram.net/storage/101.gif', '1', '1993-04-04 22:18:18', '2011-02-27 10:58:43');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('12', 'cum', 'https://telegram.net/storage/102.gif', '2', '2008-08-23 23:42:28', '2001-10-17 08:26:07');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('13', 'suscipit', 'https://telegram.net/storage/103.gif', '3', '2009-11-26 09:08:12', '2010-09-14 00:30:48');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('14', 'et', 'https://telegram.net/storage/104.gif', '4', '1971-01-28 08:30:04', '1992-10-03 07:29:38');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('15', 'dignissimos', 'https://telegram.net/storage/105.gif', '5', '1989-09-11 12:35:26', '1981-05-01 01:03:12');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('16', 'voluptas', 'https://telegram.net/storage/106.gif', '6', '1986-10-25 20:57:53', '2018-02-02 21:06:20');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('17', 'esse', 'https://telegram.net/storage/107.gif', '7', '1977-06-27 22:07:12', '1982-09-28 21:22:31');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('18', 'porro', 'https://telegram.net/storage/108.gif', '8', '1983-05-31 22:30:35', '2018-09-04 02:42:28');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('19', 'dolore', 'https://telegram.net/storage/109.gif', '9', '2007-10-29 11:46:35', '1995-09-04 21:20:44');
INSERT INTO `stickers` (`id`, `name`, `file`, `sticker_pack_id`, `created_at`, `updated_at`) VALUES ('20', 'minus', 'https://telegram.net/storage/110.gif', '10', '2016-08-24 19:01:52', '1988-11-05 03:40:02');

DROP TABLE IF EXISTS attachment_types;
CREATE TABLE attachment_types(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
 ) COMMENT 'Справочник типов вложений';

INSERT INTO attachment_types (name) VALUES ('text');
INSERT INTO attachment_types (name) VALUES ('photo');
INSERT INTO attachment_types (name) VALUES ('music');
INSERT INTO attachment_types (name) VALUES ('video');
INSERT INTO attachment_types (name) VALUES ('excel');
INSERT INTO attachment_types (name) VALUES ('pdf');
INSERT INTO attachment_types (name) VALUES ('others');

DROP TABLE IF EXISTS attachments;
CREATE TABLE attachments(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  filename VARCHAR(255) NOT NULL COMMENT 'Ссылка на местоположение файла',
  attachment_type_id BIGINT UNSIGNED COMMENT 'Ссылка на справочник типов вложений',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (attachment_type_id) REFERENCES attachment_types(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
 ) COMMENT 'Таблица вложений, вложения создаются от имени юзера';

INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('1', '6', 'enim', '1', '2009-08-26 05:56:18', '1989-01-09 08:55:27');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('2', '7', 'expedita', '2', '2001-08-08 12:11:27', '1974-06-22 10:03:26');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('3', '2', 'nam', '3', '1983-11-30 06:35:07', '2011-11-20 15:21:31');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('4', '9', 'excepturi', '4', '1996-06-24 17:05:33', '2013-12-05 03:22:12');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('5', '3', 'delectus', '5', '1994-02-06 11:57:56', '1998-08-20 08:24:46');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('6', '1', 'ipsum', '6', '1980-12-04 19:06:22', '1989-06-15 07:00:02');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('7', '8', 'molestias', '7', '1984-12-02 09:35:18', '1989-04-21 16:30:45');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('8', '3', 'optio', '1', '2009-03-12 16:18:54', '2011-07-31 09:22:38');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('9', '9', 'possimus', '2', '1990-12-29 15:52:37', '1987-03-11 06:41:41');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('10', '7', 'odit', '3', '1990-11-08 14:35:41', '1975-07-11 22:01:15');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('11', '10', 'nesciunt', '4', '2001-04-17 19:24:54', '1985-06-30 11:04:01');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('12', '3', 'fugiat', '5', '1975-04-19 09:09:43', '2005-01-10 22:59:32');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('13', '7', 'ipsa', '6', '1992-03-08 18:06:32', '1993-11-28 06:26:30');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('14', '6', 'consectetur', '7', '1980-09-02 20:08:58', '1972-05-28 19:21:07');
INSERT INTO `attachments` (`id`, `user_id`, `filename`, `attachment_type_id`, `created_at`, `updated_at`) VALUES ('15', '1', 'ex', '1', '2013-12-07 07:57:47', '2004-04-10 08:17:48');

DROP TABLE IF EXISTS text_messages;
CREATE TABLE text_messages(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  from_account_id BIGINT UNSIGNED NOT NULL,
  to_account_id BIGINT UNSIGNED NOT NULL,
  body TEXT COMMENT 'Текст сообщения, NULL если отправлен стикер',
  attachment_id BIGINT UNSIGNED COMMENT 'Ссылка на вложение, NULL если отправлен стикер',
  sticker_id BIGINT UNSIGNED COMMENT 'Ссылка на таблицу стикеров, NULL если отправлен текст сообщения',
  is_delivered BOOLEAN COMMENT 'Признак доставки',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (from_account_id) REFERENCES accounts(id),
  FOREIGN KEY (to_account_id) REFERENCES accounts(id),
  FOREIGN KEY (sticker_id) REFERENCES stickers(id),
  FOREIGN KEY (attachment_id) REFERENCES attachments(id),
  CHECK (body IS NOT NULL OR sticker_id IS NOT NULL) 
 ) COMMENT 'Таблица текстовых сообщений'; 

INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('1', '1', '3', 'Nesciunt incidunt cupiditate in possimus voluptatem. Dolores perferendis voluptatem sit ducimus. Ratione omnis laborum odio. Excepturi ipsa quo sint repellendus illo.', '15', NULL, 1, '1994-05-08 08:53:08', '1999-06-30 00:35:59');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('2', '2', '5', 'Reprehenderit libero dolorem consequatur quia. Aut quasi ut quibusdam non illum. Id enim et est excepturi eligendi. Voluptas repudiandae hic sit itaque autem ut laboriosam.', '3', NULL, 1, '1995-04-09 11:30:33', '1998-11-30 11:21:13');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('3', '2', '1', NULL, NULL, '1', 0, '1971-01-31 02:42:17', '2005-10-16 03:10:46');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('4', '2', '3', NULL, NULL, '4', 1, '1980-09-11 14:12:00', '2006-03-21 04:16:28');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('5', '5', '7', 'Enim nihil nam esse hic ut. Omnis labore dignissimos est non id sunt doloremque aliquid. In quisquam molestiae sint nulla iure.', NULL, NULL, 0, '1982-10-30 16:33:16', '1992-10-18 13:13:48');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('6', '3', '5', NULL, NULL, '6', 1, '2002-03-03 11:38:50', '1991-04-15 18:27:01');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('7', '4', '8', 'Illum blanditiis corporis alias voluptas sed fuga maiores. Adipisci illum commodi a quas esse dolores. Molestias sint velit atque alias commodi vel quos omnis.', NULL, NULL, 1, '2000-12-02 00:20:02', '2009-06-21 09:53:52');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('8', '6', '8', 'Non est eligendi aut officia molestias consequatur. Vel natus perspiciatis consequatur accusamus sit consequatur doloribus.', '1', NULL, 1, '2017-04-12 15:37:18', '2012-06-23 14:47:58');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('9', '8', '6', 'Culpa adipisci et dolores nemo ea nam. Quod reprehenderit recusandae voluptates ut. Dolorem eaque et provident libero provident enim molestiae. Tenetur beatae omnis voluptatem minima unde vel eum est.', '7', NULL, 0, '1974-07-26 13:20:21', '2019-11-25 02:53:33');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('10', '8', '6', NULL, NULL, '10', 1, '2005-12-13 16:11:06', '1972-07-17 04:16:00');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('11', '1', '2', 'Consequatur ut voluptatibus error qui. Suscipit accusantium ex sint voluptas illo quia tempora. Non magnam qui et porro praesentium totam nobis.', NULL, NULL, 1, '2014-03-19 14:55:03', '1999-08-07 06:13:28');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('12', '2', '1', 'Rerum rerum reiciendis eum sit adipisci sed. Sed ducimus neque eum perspiciatis odio et nisi aspernatur. Quia sit aut ex non. Fuga labore incidunt est qui porro perferendis.', NULL, NULL, 1, '2009-11-07 03:44:30', '1980-12-01 03:43:57');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('13', '8', '6', NULL, NULL, '4', 1, '1977-09-18 06:34:51', '1973-10-11 03:13:24');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('14', '5', '3', NULL, NULL, '4', 1, '2015-10-30 19:45:59', '2016-09-26 04:15:39');
INSERT INTO `text_messages` (`id`, `from_account_id`, `to_account_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('15', '10', '12', NULL, NULL, '1', 0, '1994-05-03 05:17:08', '1997-09-17 17:40:28');

SELECT * FROM text_messages

DROP TABLE IF EXISTS channels;
CREATE TABLE channels(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(255) NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на создателя (владельца) канала',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
  FOREIGN KEY (user_id) REFERENCES users(id)
 ) COMMENT 'Таблица каналов, создаются от имени юзера'; 

INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('1', 'et', '1', '2005-05-07 22:49:09', '2018-01-14 17:14:56');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('2', 'consectetur', '1', '2001-04-21 14:59:10', '1991-04-10 01:28:39');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('3', 'quas', '3', '1974-11-19 11:14:16', '1978-06-30 20:56:33');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('4', 'et', '2', '2002-04-08 21:49:49', '2001-12-08 20:44:37');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('5', 'aut', '2', '1990-02-27 20:14:56', '1982-10-13 20:21:45');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('6', 'sit', '2', '1977-05-26 01:25:46', '2008-12-07 21:21:02');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('7', 'perferendis', '7', '2018-03-06 16:12:24', '1978-07-12 01:11:31');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('8', 'rerum', '7', '1986-02-18 23:30:10', '1997-12-16 13:21:56');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('9', 'minima', '9', '1979-11-01 10:37:47', '2006-03-02 20:41:36');
INSERT INTO `channels` (`id`, `name`, `user_id`, `created_at`, `updated_at`) VALUES ('10', 'libero', '10', '1997-09-28 06:43:51', '2019-06-05 05:35:27');

DROP TABLE IF EXISTS channels_subscribers;
CREATE TABLE channels_subscribers(
  channel_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на канал',
  account_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на аккаунт подписчика',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (channel_id, account_id),
  FOREIGN KEY (channel_id) REFERENCES channels(id),
  FOREIGN KEY (account_id) REFERENCES accounts(id)
   ) COMMENT 'Таблица подписчиков каналов';

INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('1', '1', '1990-07-26 01:27:43', '1987-01-08 05:11:47');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('2', '1', '1981-11-11 15:37:29', '1980-10-25 05:12:01');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('3', '6', '1981-11-05 02:45:01', '2006-03-03 22:51:56');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('3', '8', '1977-07-02 02:34:29', '2000-01-06 11:51:45');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('4', '7', '2000-08-11 04:35:31', '1984-10-24 09:11:09');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('4', '6', '2014-01-12 09:55:38', '1975-10-26 04:29:48');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('5', '5', '1973-07-30 11:12:49', '1973-09-23 10:33:20');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('5', '3', '1981-11-05 02:45:01', '2006-03-03 22:51:56');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('5', '4', '2000-08-11 04:35:31', '1984-10-24 09:11:09');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('5', '6', '1973-07-30 11:12:49', '1973-09-23 10:33:20');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('5', '8', '2020-12-12 11:50:13', '1981-12-24 12:23:53');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('6', '8', '2020-12-12 11:50:13', '1981-12-24 12:23:53');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('7', '8', '2014-01-12 09:55:38', '1975-10-26 04:29:48');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('7', '10', '1981-08-13 10:53:54', '1985-12-06 12:57:07');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('8', '8', '1977-07-02 02:34:29', '2000-01-06 11:51:45');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('9', '1', '2001-10-19 10:40:46', '1982-08-28 02:28:31');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('9', '10', '2001-10-19 10:40:46', '1982-08-28 02:28:31');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('10', '1', '1981-08-13 10:53:54', '1985-12-06 12:57:07');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('10', '3', '1990-07-26 01:27:43', '1987-01-08 05:11:47');
INSERT INTO `channels_subscribers` (`channel_id`, `account_id`, `created_at`, `updated_at`) VALUES ('10', '2', '1981-11-11 15:37:29', '1980-10-25 05:12:01');

SELECT * FROM channels_subscribers

DROP TABLE IF EXISTS channel_posts;
CREATE TABLE channel_posts(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  channel_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на канал',
  body TEXT COMMENT 'Текст поста',
  attachment_id BIGINT UNSIGNED COMMENT 'Ссылка на вложение',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (channel_id) REFERENCES channels(id),
  FOREIGN KEY (attachment_id) REFERENCES attachments(id)
  ) COMMENT 'Таблица постов каналов';
 
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('1', '10', 'Harum dolorum et est et nihil ratione. Dolorum aut quisquam laborum totam aperiam unde. Id qui facere non dolorum mollitia. Aut expedita nihil id nostrum natus.', '10', '2015-06-18 23:29:04', '1998-05-24 01:23:41');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('2', '6', 'Eum suscipit atque excepturi facere. Impedit ipsum voluptatem et voluptate temporibus dolores omnis. Minima ex dolor exercitationem ut. Provident odio esse odit qui voluptate atque.', '11', '1971-05-11 18:44:19', '2017-05-29 10:31:51');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('3', '3', 'Ducimus enim quibusdam officiis ducimus ut consequuntur. Quidem recusandae amet reiciendis omnis praesentium. Unde ut molestiae sunt ut expedita dicta est. Aliquid placeat hic est expedita voluptate quaerat rem explicabo. Aut quis eaque veniam neque itaque.', NULL, '1989-01-01 23:58:38', '1975-06-29 05:56:03');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('4', '5', 'Omnis sed doloribus commodi perferendis nisi. Dolor magnam consequatur rerum magnam qui voluptate. Eum sunt quaerat et. Rerum asperiores eius cupiditate reiciendis.', '12', '1971-02-10 13:56:18', '1995-04-21 00:07:34');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('5', '4', 'Provident consequatur quos ut nemo enim rem. Dolorem quae libero facilis aut. Quo qui quam cumque iure repellat. Magnam reiciendis aut quis eos odio facilis.', NULL, '2012-10-24 19:01:16', '2001-07-22 08:54:02');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('6', '7', 'Blanditiis harum laboriosam tenetur fuga cumque libero. Voluptatem asperiores tempore distinctio ut et aspernatur ab. Molestias sunt cupiditate est qui itaque.', NULL, '1994-12-27 04:03:04', '1983-10-15 00:14:28');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('7', '8', 'Sed laboriosam cumque illo quis veniam. Iure et laboriosam eum ex dolores deleniti veniam inventore. Ut amet autem ullam impedit.', '13', '1976-06-29 21:46:03', '1990-12-03 18:30:35');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('8', '1', 'Voluptatum deleniti minima architecto sed est consequatur. Maiores consequatur voluptas culpa ex. Temporibus qui qui dicta delectus minus veniam.', '14', '1992-10-02 05:45:14', '1984-09-10 05:19:32');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('9', '2', 'Sit fugit quia consectetur rerum voluptatem. Molestiae nulla a minus quod accusamus harum exercitationem. In eligendi a dolorem nesciunt deserunt.', NULL, '2014-12-29 07:48:03', '1970-06-07 10:22:27');
INSERT INTO `channel_posts` (`id`, `channel_id`, `body`, `attachment_id`, `created_at`, `updated_at`) VALUES ('10', '9', 'Aliquam laboriosam tempora voluptatem consequatur impedit. Maiores et qui temporibus ullam asperiores sequi. Voluptatem aut quod dolores voluptatem qui id velit.', '15', '2019-03-24 19:13:59', '2016-05-12 14:23:01');

 
 DROP TABLE IF EXISTS groups_;
 CREATE TABLE groups_(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(255) NOT NULL,
  account_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на администратора (создателя) группы',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
  FOREIGN KEY (account_id) REFERENCES accounts(id)
  ) COMMENT 'Таблица групп пользователей, создаются от имени аккаунта';
 
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('1', 'ipsam', '3', '2003-01-29 05:26:44', '2011-03-14 02:35:51');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('2', 'qui', '6', '2001-01-05 17:30:42', '1979-02-23 11:55:15');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('3', 'officiis', '6', '2019-11-27 02:05:41', '1989-01-04 02:26:16');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('4', 'natus', '6', '2003-10-31 15:37:21', '2021-08-22 19:46:33');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('5', 'recusandae', '2', '1996-01-06 18:21:23', '1971-09-18 04:07:33');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('6', 'dolores', '1', '2019-07-08 22:08:37', '1977-12-24 10:19:00');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('7', 'fugiat', '7', '1981-08-31 23:06:30', '1999-04-12 18:14:23');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('8', 'aut', '9', '1976-05-12 04:32:35', '2018-06-26 20:06:13');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('9', 'qui', '4', '1988-05-04 16:34:09', '2004-12-31 23:41:35');
INSERT INTO `groups_` (`id`, `name`, `account_id`, `created_at`, `updated_at`) VALUES ('10', 'quo', '4', '1992-12-10 20:14:58', '2021-08-23 11:51:57');
 
 DROP TABLE IF EXISTS group_members;
 CREATE TABLE group_members(
  group_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на группу',
  account_id BIGINT UNSIGNED NOT NULL COMMENT 'Ссылка на аккаунт подписчика',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (group_id, account_id),
  FOREIGN KEY (group_id) REFERENCES groups_(id),
  FOREIGN KEY (account_id) REFERENCES accounts(id)
  ) COMMENT 'Таблица членов групп';

INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('1', '1', '1999-11-05 20:00:43', '2002-02-20 22:58:15');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('1', '6', '1979-06-09 13:24:29', '1972-08-18 05:03:29');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('1', '8', '1989-11-02 23:37:54', '1982-08-13 04:30:32');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('2', '2', '1994-10-06 13:43:21', '2010-03-13 05:09:38');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('2', '9', '1974-07-06 00:38:38', '2012-07-27 00:54:26');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('3', '3', '1995-04-02 07:19:19', '1995-01-19 21:10:21');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('3', '7', '2021-06-08 19:21:55', '1985-06-30 22:08:06');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('3', '8', '2009-08-27 21:20:35', '1980-11-26 11:24:40');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('3', '9', '2010-05-20 01:45:08', '1986-06-30 13:03:05');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('4', '4', '2012-07-11 13:01:19', '1987-08-11 19:57:31');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('4', '1', '1999-11-05 20:00:43', '2002-02-20 22:58:15');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('5', '5', '1979-06-09 13:24:29', '1972-08-18 05:03:29');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('5', '3', '1989-11-02 23:37:54', '1982-08-13 04:30:32');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('6', '6', '1994-10-06 13:43:21', '2010-03-13 05:09:38');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('6', '8', '1974-07-06 00:38:38', '2012-07-27 00:54:26');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('7', '7', '1995-04-02 07:19:19', '1995-01-19 21:10:21');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('7', '4', '2021-06-08 19:21:55', '1985-06-30 22:08:06');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('7', '8', '2009-08-27 21:20:35', '1980-11-26 11:24:40');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('8', '8', '2010-05-20 01:45:08', '1986-06-30 13:03:05');
INSERT INTO `group_members` (`group_id`, `account_id`, `created_at`, `updated_at`) VALUES ('8', '10', '2012-07-11 13:01:19', '1987-08-11 19:57:31');

SELECT * FROM group_members gm 

DROP TABLE IF EXISTS group_messages;
 CREATE TABLE group_messages(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  from_account_id BIGINT UNSIGNED NOT NULL,
  to_group_id BIGINT UNSIGNED NOT NULL,
  body TEXT COMMENT 'Текст сообщения, NULL если отправлен стикер',
  attachment_id BIGINT UNSIGNED COMMENT 'Ссылка на вложение',
  sticker_id BIGINT UNSIGNED COMMENT 'Ссылка на таблицу стикеров, NULL если отправлен текст сообщения',
  is_delivered BOOLEAN COMMENT 'Признак доставки',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (from_account_id) REFERENCES accounts(id),
  FOREIGN KEY (to_group_id) REFERENCES groups_(id),
  FOREIGN KEY (sticker_id) REFERENCES stickers(id),
  FOREIGN KEY (attachment_id) REFERENCES attachments(id)
  ) COMMENT 'Таблица внутригрупповых сообщений';

INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('1', '1', '1', 'Et dolores totam aliquam dolorum. Officia molestiae mollitia sed dolore officiis. Velit omnis voluptate magnam vel in in voluptatem.', '10', NULL, 1, '1984-06-15 14:53:06', '2016-03-17 01:59:41');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('2', '6', '1', 'Perferendis assumenda autem molestias assumenda sed dolorem ducimus. Sit nisi distinctio excepturi voluptatibus unde dolorem sed.', '12', NULL, 1, '1971-09-14 18:20:47', '1974-05-23 04:50:58');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('3', '9', '3', 'Vel voluptatum qui et deleniti. Fuga aperiam velit sed repudiandae est minus voluptatem.', NULL, '3', 1, '1985-09-30 11:42:12', '2000-06-05 08:04:40');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('4', '3', '3', NULL, NULL, '4', 1, '1991-09-28 10:57:11', '1976-12-25 21:57:03');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('5', '7', '3', NULL, NULL, '1', 1, '1991-08-04 19:34:46', '2012-07-12 03:57:50');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('6', '9', '3', 'Nam cum nihil eos excepturi dignissimos. Ea et illo et nisi sint voluptatem asperiores ipsam. Velit corporis quae sapiente explicabo ut nostrum. Iste id id rerum doloremque exercitationem aut et non. Modi cumque eum nam vitae eos recusandae facilis.', NULL, NULL, 0, '1979-03-12 05:54:25', '1997-06-07 00:15:49');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('7', '9', '2', 'Velit ut dolor voluptatem distinctio. Ab eum similique iusto veritatis quae nesciunt. Reiciendis porro aperiam odio magni accusamus sit beatae.', '15', NULL, 1, '2017-01-30 00:48:30', '2015-08-17 07:58:26');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('8', '2', '2', NULL, NULL, '8', 1, '2009-07-19 06:45:08', '1996-11-07 23:43:03');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('9', '8', '6', 'Et ipsa aliquid voluptatum magnam nam quo nam. Cumque nihil quisquam odit dolore perspiciatis pariatur. Et officia quidem et eum qui. Quod rerum ducimus facilis aut tempora animi eos.', '13', NULL, 0, '1970-04-19 09:19:49', '1970-05-31 15:18:12');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('10', '6', '6', 'Culpa ipsam corrupti sunt unde reiciendis rem. Velit laudantium sint nesciunt est inventore aspernatur ut voluptates. Ab molestiae quasi impedit ut sit non. Beatae voluptatum minus repellat et.', NULL, NULL, 1, '2001-03-05 22:33:45', '1999-03-28 07:51:19');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('11', '4', '7', 'Commodi molestiae non aut nihil fugiat. Eligendi facilis non quisquam sed. Quos perspiciatis soluta a quia voluptatibus.', NULL, NULL, 1, '2014-10-23 04:59:08', '1971-01-10 12:02:21');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('12', '8', '7', 'Suscipit maiores iure et non enim ducimus error. Vitae qui doloremque amet optio provident cumque. Sed alias itaque harum eos quia.', NULL, NULL, 1, '2007-06-29 12:59:25', '1987-03-21 18:31:22');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('13', '10', '8', 'Ullam qui rem vel deleniti quod. Soluta qui harum quo iste nemo et ad distinctio. Accusantium eum in ducimus aliquam aliquam quam fugiat totam. Molestiae dolorum sunt aut beatae consectetur voluptatum et maiores.', NULL, NULL, 0, '1981-08-19 10:10:54', '1970-02-13 05:54:46');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('14', '3', '5', NULL, NULL, '1', 0, '1984-04-17 17:52:11', '1971-09-04 08:37:20');
INSERT INTO `group_messages` (`id`, `from_account_id`, `to_group_id`, `body`, `attachment_id`, `sticker_id`, `is_delivered`, `created_at`, `updated_at`) VALUES ('15', '5', '5', 'Libero modi reprehenderit quos ullam accusamus voluptate nam consequuntur. Voluptatibus ut consequuntur animi placeat sint dolorum quas.', NULL, NULL, 1, '2005-05-25 19:26:30', '2017-01-25 18:55:39');


