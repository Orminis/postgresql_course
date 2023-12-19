CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR
AS
$$
	DECLARE
		full_name VARCHAR;
	BEGIN
		IF 
			first_name IS NULL AND last_name IS null THEN
				RETURN null;
		ELSEIF 
			first_name IS NULL THEN
				RETURN last_name;
		ELSEIF 
			last_name IS NULL THEN
				RETURN first_name;
		ELSE
			full_name := CONCAT(INITCAP(first_name), ' ', INITCAP(last_name));
			RETURN full_name;
		END IF;
	END;
$$
LANGUAGE plpgsql
;
SELECT fn_full_name('fred', 'sanford');
SELECT fn_full_name('', 'SIMPSONS');
SELECT fn_full_name('JOHN', '');
SELECT fn_full_name(NULL, NULL);


-- 02.User-defined Function Future Value

DROP FUNCTION fn_calculate_future_value;

CREATE OR REPLACE FUNCTION fn_calculate_future_value(
	initial_sum DECIMAL
	, yearly_interest_rate DECIMAL
	, number_of_years INT)
RETURNS DECIMAL
AS
$$
	DECLARE
		future_value DECIMAL;
	BEGIN
		future_value := initial_sum * (POWER((1 + yearly_interest_rate), number_of_years));
		RETURN TRUNC(future_value, 4);
	END;
$$
LANGUAGE plpgsql
;
SELECT fn_calculate_future_value (1000, 0.1, 5);
SELECT fn_calculate_future_value (2500, 0.30, 2);
SELECT fn_calculate_future_value (500, 0.25, 10);
SELECT fn_calculate_future_value (1400, 0.15, 5);