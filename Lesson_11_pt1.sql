USE sample

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
table_name VARCHAR(100),
id_primary_key BIGINT UNSIGNED,
name VARCHAR(255),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP)
ENGINE=Archive
;

SELECT * FROM users u 

DELIMITER //
DROP TRIGGER IF EXISTS log_users//
CREATE TRIGGER log_users AFTER INSERT ON users
FOR EACH ROW BEGIN 
	INSERT INTO logs (table_name, id_primary_key,name) VALUES ('users', NEW.id, NEW.name);
END//
DELIMITER ;

INSERT INTO users (name) VALUES ('Евгений');

SELECT * FROM logs l 

DELIMITER //
DROP TRIGGER IF EXISTS log_catalogs//
CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW BEGIN 
	INSERT INTO logs (table_name, id_primary_key,name) VALUES ('catalogs', NEW.id, NEW.name);
END//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS log_products//
CREATE TRIGGER log_products AFTER INSERT ON products
FOR EACH ROW BEGIN 
	INSERT INTO logs (table_name, id_primary_key,name) VALUES ('products', NEW.id, NEW.name);
END//
DELIMITER ;

INSERT INTO catalogs (name) VALUES ('Насосы');
INSERT INTO products (name) VALUES ('dtx1980');

SELECT * FROM logs l 
