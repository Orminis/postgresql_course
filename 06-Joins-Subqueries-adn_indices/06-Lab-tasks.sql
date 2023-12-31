-- 01.Towns Addresses

SELECT
	t.town_id
	,t.name as town_name
	,a.address_text
FROM 
	towns as t
		JOIN addresses as a
			ON t.town_id = a.town_id
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY
	t.town_id
	,a.address_id
;

-- 02. Managers
SELECT 
	e.employee_id
	,CONCAT(e.first_name, ' ', e.last_name) as full_name
	,d.department_id
	,d.name
FROM 
	employees as e
		RIGHT JOIN 
			departments as d
				on e.employee_id = d.manager_id
ORDER BY 
	e.employee_id ASC
LIMIT(5)
;

-- 03.Employees’ Projects
SELECT 
	e.employee_id
	,CONCAT(e.first_name, ' ', e.last_name) AS full_name
	,p.project_id
	,p.name
FROM
	employees AS e
		JOIN employees_projects AS e_p
			ON e.employee_id = e_p.employee_id
				JOIN projects AS p
					ON e_p.project_id = p.project_id
WHERE 
	p.project_id = 1
;


-- 04.Higher Salary
SELECT
	COUNT(*)
FROM
	employees AS e
WHERE
	e.salary > (SELECT AVG(salary) FROM employees) 
;