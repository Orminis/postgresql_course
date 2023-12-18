-- 01 Count Employees by Town
CREATE OR REPLACE FUNCTION fn_count_employees_by_town(town_name VARCHAR)
RETURNS INT
AS 

$$
	DECLARE 
		town_count INT;
	BEGIN
		SELECT
			COUNT(*) 
		FROM
			employees AS e
			JOIN
				addresses AS a
				ON 
					e.address_id = a.address_id
					JOIN
						towns AS t
						ON
							a.town_id = t.town_id
		WHERE t.name = town_name
	INTO town_count;
	RETURN town_count;
	END;
$$

LANGUAGE plpgsql
;

SELECT fn_count_employees_by_town('Sofia')

-- 2.Employees Promotion
CREATE OR REPLACE PROCEDURE sp_decrease_salaries(department_name VARCHAR)
AS
$$
	BEGIN
		UPDATE 
			employees
		SET
			salary = salary - salary * 0.05
		WHERE department_id = 
			(
			SELECT 
				d.department_id
			FROM
				departments AS d
			WHERE d.name = department_name
			);
	END;
$$
LANGUAGE plpgsql
;


CREATE PROCEDURE sp_increase_salaries(department_name VARCHAR)
AS
$$
	BEGIN
		UPDATE 
			employees
		SET
			salary = salary + salary * 0.05
		WHERE department_id = 
			(
			SELECT 
				d.department_id
			FROM
				departments AS d
			WHERE d.name = department_name
			);
	END;
$$
LANGUAGE plpgsql
;


CALL sp_decrease_salaries('Finance');

CALL sp_increase_salaries('Finance');

-- 03.Employees Promotion by ID
CREATE PROCEDURE sp_increase_salary_by_id(id INT)
AS 
$$
BEGIN
	IF (
		SELECT 
			salary
		FROM
			employees
		WHERE 
			employee_id = id
		) IS NULL THEN
		RETURN;
	ELSE
		UPDATE
			employees
		SET
			salary = salary + (0.05 * salary)
		WHERE
			id = employee_id;
	END IF;
	COMMIT;	
END;	
$$
LANGUAGE plpgsql
;

-- 04.Triggered
CREATE TABLE deleted_employees(
	employee_id SERIAL PRIMARY KEY
	, first_name VARCHAR(20)
	, last_name VARCHAR(20)
	, middle_name VARCHAR(20)
	, job_title VARCHAR(50)
	, deparment_id INT
	, salary NUMERIC(19, 4)
	)
;

CREATE OR REPLACE FUNCTION fn_backup_fired_employees()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO deleted_employees(
		 first_name
		, last_name
		, middle_name
		, job_title
		, deparment_id
		, salary
	)
	VALUES (
		old.first_name
		,old.last_name
		,old.middle_name
		,old.job_title
		,old.department_id
		,old.salary
		);
	RETURN new;
END;
$$

LANGUAGE plpgsql
;

CREATE OR REPLACE TRIGGER backup_employees
AFTER DELETE ON employees
FOR EACH ROW
EXECUTE PROCEDURE fn_backup_fired_employees();
