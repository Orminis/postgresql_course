/*
-- 01
-- CREATE TABLE 
-- 	employees(
-- 		"id" SERIAL PRIMARY KEY NOT NULL,
-- 		first_name VARCHAR(30),
-- 		last_name VARCHAR(50),
-- 		hiring_date DATE DEFAULT '2023-01-01',
-- 		salary NUMERIC(10, 2),
-- 		devices_number INT
-- 	);

-- CREATE TABLE 
-- 	departments(
-- 		"id" SERIAL PRIMARY KEY NOT NULL,
-- 		"name" VARCHAR(50),
-- 		code CHAR(3),
-- 		description TEXT
-- 	);

-- CREATE TABLE 
-- 	issues(
-- 		"id" SERIAL PRIMARY KEY UNIQUE,
-- 		description VARCHAR(150),
-- 		"date" DATE,
-- 		"start" TIMESTAMP
-- 	);


-- 02
-- INSERT INTO employees VALUES
-- 	('1', 'ivan', 'ivanov', '2020-01-05', 1000, 105);

-- 03
-- ALTER TABLE employees
-- ADD COLUMN middle_name VARCHAR(50);

-- 04
-- ALTER TABLE employees
-- 	ALTER salary SET NOT NULL,
-- 	ALTER salary SET DEFAULT 0,
-- 	ALTER hiring_date SET NOT NULL;

-- 05
-- ALTER TABLE employees
-- ALTER middle_name TYPE VARCHAR(100);

-- 06
-- TRUNCATE TABLE issues;

-- 07 
-- DROP TABLE departments;
*/


-- Primary Key column as Identity
-- CREATE TABLE <table name>(
-- 	'id' INT PRIMARY KEY generated always as IDENTITY
-- 	,first_name VARCHAR(30)
-- 	,last_name VARCHAR(30)
-- )
