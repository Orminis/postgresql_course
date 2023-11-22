-- 01
SELECT *
FROM cities
ORDER BY "id"
;

-- 02
SELECT 
	CONCAT(name, ' ', state) AS "Cities Information"
	,area AS "Area (km2)" 
FROM 
	cities
ORDER BY "id"
;

-- 03
SELECT 
 	DISTINCT ON ("name")
 	"name"
 	,area as "Area (km2)"
FROM 
 	cities
ORDER BY
 	"name" DESC
;

-- 04
SELECT 
	"id" AS "ID"
	,CONCAT(first_name, ' ', last_name) AS "Full Name"
	,job_title AS "Job Title"
FROM employees
ORDER BY
	first_name ASC
LIMIT 50
;

-- 05
SELECT 
	"id"
	,CONCAT(first_name,' ', middle_name,' ', last_name) AS "Full Name"
	,hire_date AS "Hire Date"
FROM 
	employees
ORDER BY
	hire_date ASC
OFFSET 9;


-- 06
SELECT 
	"id"
	,CONCAT(number,' ', street) AS "Address"
	,city_id
FROM 
	addresses
WHERE
	"id" >= 20
;

-- 07
SELECT 
	CONCAT("number", ' ', "street") AS "Address"
	,city_id
FROM
	addresses
WHERE 
	city_id % 2 = 0
ORDER BY 
	city_id ASC
;

-- 08

SELECT 
	name
	,start_date
	,end_date
FROM
	projects
WHERE
	start_date >= '2016-06-01 07:00:00' 
	AND
	end_date < '2023-06-04 00:00:00'
ORDER BY 
	start_date ASC
;

--09
SELECT 
	number
	,street
FROM 
	addresses
WHERE 
	("id" >= 50 AND "id" <= 100)
	OR
	"number" < 1000
;

-- 10
SELECT	
	employee_id
	,project_id
FROM
	employees_projects
WHERE
	employee_id IN (200, 250)
	AND
	project_id NOT IN (50, 100)
;

-- 11
SELECT 
	name
	,start_date
FROM
	projects
WHERE 
	name in ('Mountain', 'Road', 'Touring')
LIMIT 20
;

-- 12
SELECT 
	CONCAT(first_name, ' ', last_name) AS "Full Name"
	,job_title
	,salary
FROM
	employees
WHERE
	salary IN (12500, 14000, 23600, 25000)
ORDER BY
	salary DESC
;

-- 13
SELECT
	"id"
	,first_name
	,last_name
FROM
	employees
WHERE
	middle_name IS null
LIMIT 3
;

-- 14
INSERT INTO departments (department, manager_id)
VALUES 
	('Finance', 3),
	('Information Services', 42),
	('Document Control', 90),
	('Quality Assurance', 274),
	('Facilities and Maintenance', 218),
	('Shipping and Receiving', 85),
	('Executive', 109)
RETURNING *
;

-- 15
CREATE TABLE IF NOT EXISTS
	company_chart 
-- 	(
-- 		"Full Name", 
-- 		"Job Title", 
-- 		"Department ID", 
-- 		"Manager ID"
-- 	)
AS 
SELECT 
	CONCAT(e.first_name, ' ', e.last_name) AS "Full Name"
	,e.job_title AS "Job Title" 
	,e.department_id AS "Department ID"
	,e.manager_id AS "Manager ID"
FROM employees AS e
;

-- 16
SELECT *
FROM projects
ORDER BY "id"
WHERE end_date is NULL;


UPDATE projects
SET end_date = start_date + INTERVAL '5 months'
WHERE end_date is NULL
;

-- 17
SELECT *
FROM 
	employees
WHERE 
	hire_date >= '1998-01-01'
	AND hire_date <= '2000-01-05'
ORDER BY 
	hire_date ASC
;

UPDATE 
	employees
SET 
	salary = salary + 1500,
	job_title = concat('Senior',' ', job_title)
WHERE 
	hire_date >= '1998-01-01' 		-- YYYY-MM-DD
	AND hire_date <= '2000-01-05'
--  hire_date BETWEEN '1998-01-01' AND '2000-01-05' 
;


-- 18
DELETE FROM 
	addresses
WHERE 
	city_id IN (5, 17, 20, 30)
;

--19
CREATE VIEW 
	view_company_chart AS
SELECT 
	cch."Full Name"
	,cch."Job Title"
FROM company_chart as cch
WHERE 
	cch."Manager ID" = 184
;
SELECT * FROM view_company_chart;


-- 20
-- Correct way
CREATE VIEW 
	view_addresses 
AS
SELECT 
	CONCAT(e.first_name, ' ', e.last_name) AS "Full Name"
	,e.department_id
	,concat(a.number, ' ', a.street) AS "Address"
FROM 
	employees AS e
JOIN 
	addresses AS a
		ON
	e.address_id = a.id
ORDER BY "Address"
;
---------------------------------------------
-- First idea (NOT CORRECT)
-- CREATE VIEW 
-- 	view_addresses AS
-- SELECT 
-- 	CONCAT(e.first_name, ' ', e.last_name) AS "Full Name"
-- 	,e.department_id
-- 	,concat(a.number, ' ', a.street) AS "Address"
-- FROM
-- 	employees as e
-- 	,addresses as a
-- WHERE 
-- 	e.address_id = a.id
-- ORDER BY "Address"
-- ;
-- SELECT * FROM view_addresses;
---------------------------

-- 21 
ALTER VIEW IF EXISTS 
	view_addresses
RENAME TO 
	view_employee_addresses_info
;

-- 22
DROP VIEW view_company_chart;

-- 23
UPDATE 
	projects
SET 
	"name" = UPPER(name)
;

-- 24
CREATE VIEW 
	view_initials 
AS
SELECT 
	SUBSTRING(first_name, 1, 2) AS "initial"
	,last_name
FROM 
	employees
ORDER BY 
	last_name
;
SELECT * FROM view_initials;

-- 25
SELECT
	name,
	start_date	
FROM 
	projects
WHERE
	name LIKE 'MOUNT%'
;
