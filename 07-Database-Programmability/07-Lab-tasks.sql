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
