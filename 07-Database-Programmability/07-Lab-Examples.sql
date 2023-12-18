CREATE OR REPLACE FUNCTION fn_full_name(VARCHAR, VARCHAR)
RETURNS VARCHAR
AS
$$
	BEGIN
		RETURN CONCAT($1, ' ', $2);
	END
$$
LANGUAGE plpgsql
;

SELECT fn_full_name('Ivan', 'Georgiev');

-- Same function but with declared variables
CREATE OR REPLACE FUNCTION fn_full_name(VARCHAR, VARCHAR)
RETURNS VARCHAR
AS
$$
	DECLARE
		first_name ALIAS FOR $1;
		last_name ALIAS FOR $2;
	BEGIN
		RETURN CONCAT(first_name, ' ', last_name);
	END
$$
LANGUAGE plpgsql
;

SELECT fn_full_name('Vasil', 'Nedyalkov');

-- Best practice for making function
CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR
AS
$$
	DECLARE
		full_name VARCHAR;
	BEGIN
		IF 
			first_name IS NULL AND last_name IS NULL THEN
			full_name := NULL;
		ELSEIF
			first_name IS NULL THEN
			full_name := last_name;
		ELSEIF
			last_name IS NULL THEN
			full_name := first_name;
		ELSE
			full_name = CONCAT(first_name, ' ', last_name)
		END IF;
		RETURN full_name;
	END
$$
LANGUAGE plpgsql
;


-- Function to take id from given name. 
CREATE OR REPLACE FUNCTION fn_get_city_id(city_name VARCHAR)
RETURNS INT AS
$$
	--declaring id which will be returned
	DECLARE
		city_id int
	-- finding the city id from the table after searching with the name. Then city_id := id / INTO city_id;
	BEGIN
		SELECT id INTO city_id
		FROM cities
		WHERE name = city_name
		RETURN city_id;
	END
$$
LANGUAGE plpgsql
;

-- How to declare Input and output variables into function parenthesis.

-- Using additional variable, for example named status, to be used to return additional information depending of the final result of the `main` variable.

CREATE OR REPLACE FUNCTION fn_get_city_id(
	IN city_name VARCHAR
	,OUT city_id INT
	,OUT status INT
	)
AS
$$
	DECLARE
		temp_id int
	BEGIN
		SELECT id FROM cities
		WHERE name = city_name
		INTO temp_id;
		IF temp_id IS NULL THEN
			SELECT NULL, 100 INTO city_id, status;
		ELSE 
			SELECT temp_id, 0 INTO city_id, status, 
		END IF;
	END
$$
LANGUAGE plpgsql
;

-- Examples how to use the function 

INSERT INTO 
	persons(first_name, last_name, city_id)
VALUES
	('Ivan', 'Ivanov' fn_get_city_id('Varna'))
;

SELECT fn_get_city_id('Sofia');


-- STORED PROCEDURES
-- SP is used to manipulate tables/data in DBs
-- SP can call functions but functions can't call SPs.
CREATE PROCEDURE sp_add_person(first_name VARCHAR, last_name VARCHAR, city_name VARCHAR)
AS
$$
	BEGIN
		INSERT INTO persons(first_name, last_name, city_id)
		VALUE (first_name, last_name, fn_get_city_id(city_name))
	END;
$$
LANGUAGE plpgsql
;

-- Usage of stored procedures

CALL sp_add_person('Ivan', 'Nachev', 'Varna')


-- TRANSACTION
