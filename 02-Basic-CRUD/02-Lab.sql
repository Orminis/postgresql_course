-- 01
-- SELECT
-- 	"id"
-- 	,concat(first_name,' ',last_name) as "Full Name"
-- 	,job_title AS "Job Title"
	
-- FROM employees
-- SELECT 
-- 	"id"
-- 	,concat(first_name,' ',last_name) as "Full Name"
-- 	,job_title
-- 	,salary 
	
-- FROM employees

-- 02
-- SELECT
-- 	"id",
-- 	concat(first_name, ' ', last_name) as "Full Name",
-- 	job_title as "Job Title",
-- 	salary
-- FROM 
-- 	employees
-- WHERE 
-- 	salary > 1000
-- ORDER BY 
-- 	"id" DESC
-- ;

-- -- 03
-- SELECT *
-- FROM employees
-- WHERE salary >= 1000 and department_id = 4
-- ORDER BY "id";

-- 04
-- INSERT INTO 
-- 	employees(
-- 		first_name
-- 		,last_name
-- 		,job_title
-- 		,department_id
-- 		,salary
-- 	)
-- VALUES
-- 	('Samantha', 'Young', 'Housekeeping', 4, 900)
-- 	,('Roger', 'Palmer', 'Waiter', 3, 928.33)

-- RETURNING *;

--05
-- UPDATE employees
-- SET salary = salary + 100
-- WHERE job_title = 'Manager';

-- SELECT *
-- FROM employees
-- where job_title = 'Manager';

--06
-- DELETE FROM employees
-- WHERE department_id in (1, 2);

-- SELECT * 
-- FROM employees
-- ORDER BY id ASC;

--07
CREATE VIEW top_paid_employee_view
AS 
SELECT * 
FROM employees
ORDER BY salary DESC
LIMIT 1;
SELECT * FROM top_paid_employee_view;