-- 01. Departments info (by id)
SELECT
	department_id
	,count(*) AS "employee_count"
FROM
	employees
GROUP BY department_id
ORDER BY department_id
;

-- 02.Departments Info (by salary)
SELECT 
	department_id,
	count(salary)
FROM 
	employees
GROUP BY department_id
ORDER BY department_id
;

-- 03.Sum Salaries per Department
SELECT
	department_id
	,SUM(salary) AS "total_salaries"
FROM 
	employees
GROUP BY department_id
ORDER BY department_id
;

-- 4.Maximum Salary per Department and 5.Minimum Salary per Department and 6.Average Salary per Department

SELECT
	department_id
	-- 04
	,MAX(salary) as max_salary
	-- 05
	,MIN(salary) AS min_salary
	-- 06
	,AVG(salary) AS avg_salary
FROM
	employees
GROUP BY department_id
ORDER BY department_id
;

-- 07.Filter Total Salaries

SELECT 
	department_id
	,SUM("salary") as "Total Salary"
FROM
	employees
GROUP BY 
	department_id
HAVING
	SUM("salary") < 4200
ORDER BY 
	department_id
;

-- 08.Department Names
SELECT
	"id"
	,"first_name"
	,"last_name"
	,trunc("salary", 2)
	,"department_id"
	,CASE 
		WHEN department_id = 1 THEN 'Management'
		WHEN department_id = 2 THEN 'Kitchen Staff'
		WHEN department_id = 3 THEN 'Service Staff'
	ELSE 
		'Other'
	END AS "Department Name"
	
	-- Simple case 
	--,CASE department_id
	--	WHEN  1 THEN 'Management'
	--	WHEN  2 THEN 'Kitchen Staff'
	--	WHEN  3 THEN 'Service Staff'
	--ELSE 
	--	'Other'
	--END AS "Department Name"

FROM
	employees
ORDER BY 
	"id"
;