
USE rasbetDB;

CREATE USER 'javaBackend'@'localhost' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON *.* TO 'javaBackend'@'localhost';
FLUSH PRIVILEGES;