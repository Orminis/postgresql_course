-- 01 
CREATE OR REPLACE VIEW
	view_river_info
AS
	SELECT 
		CONCAT_WS(' ', 
			   'The river'
			   ,r.river_name
			   ,'flows into the'
			   ,r.outflow 
			   ,'and is' 
			   ,r.length
			   ,'kilometers long.')
	FROM rivers AS r
	ORDER BY r.river_name;

SELECT
	*
FROM
	view_river_info;

	
-- 2. Concatenate Geography Data
CREATE OR REPLACE VIEW
	"view_continents_countries_currencies_details"
AS
SELECT 
	CONCAT(
		TRIM(con.continent_name)
		,': '
		,TRIM(con.continent_code)
		)
			AS "Continent Details"
	,CONCAT_WS(
		' - '
		,TRIM(ctr.country_name)
		,TRIM(ctr.capital)
		,ctr.area_in_sq_km
		,'km2'
		)	
			AS "Country Information"
	,CONCAT(
		cur.description
		,' ('
		,cur.currency_code
		,')'
		)
			AS "Currencies"
FROM 
	continents AS con
	,countries AS ctr
	,currencies AS cur
WHERE 
	con.continent_code = ctr.continent_code
	AND
	ctr.currency_code = cur.currency_code
ORDER BY 
	"Country Information" ASC
	,"Currencies" ASC
;


-- 03. Capital Code
ALTER TABLE
	countries
ADD COLUMN
	capital_code CHAR(2);

UPDATE
	countries
SET
	capital_code = SUBSTRING(capital, 1, 2);
	
-- 04.(Desc)ription
SELECT 
	SUBSTRING(description, 5) AS "substring"
	-- RIGHT(description, -4) AS "substring"
FROM 
	currencies


-- 05.River Length
SELECT 
	(REGEXP_MATCHES("River Information", '([0-9]{1,4})'))[1] AS river_lenght
FROM view_river_info
;

-- 06. Replace A/a

SELECT 
	REPLACE(mountain_range, 'a', '@') AS "replace_a"
	,REPLACE(mountain_range, 'A', '$') AS "replace_A"
FROM
	mountains
;


-- 07. Translate
SELECT
	capital,
	TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') as "translated_name"
FROM
	countries
;

-- 08.Leading
SELECT
	continent_name,
	TRIM(LEADING FROM continent_name) as "trim"
	-- LTRIM(continent_name) as "trim"
FROM continents

-- 09. Trailing
SELECT
	continent_name,
	TRIM(TRAILING FROM continent_name) as "trim"
	-- RTRIM(continent_name) as "trim"
FROM continents

-- 10. LTRIM & RTRIM
SELECT 
	LTRIM(peak_name, 'M') AS "Left Trim"
	,RTRIM(peak_name, 'm') AS "Right Trim"

FROM peaks

-- 11. Character Length and Bits
SELECT 
	CONCAT(
		m.mountain_range
		,' '
		,p.peak_name
		) AS "Mountain Information"
	,CHAR_LENGTH(
		CONCAT(
			m.mountain_range
			,' '
			,p.peak_name
			)
		) AS "Character Length"
	,BIT_LENGTH(
		CONCAT(
			m.mountain_range
			,' '
			,p.peak_name
			)
		) AS "Bits of a String"
FROM 
 	mountains as m,
	peaks as p
WHERE
	m."id" = p.mountain_id
;


-- 12. Length of a Number
SELECT 
	population
	,LENGTH(CAST(population AS VARCHAR)) AS "length" 
FROM countries;

-- 13 Positive and Negative LEFT
SELECT
	peak_name
	,LEFT(peak_name, 4) AS "Positive Left"
	,LEFT(peak_name, -4) AS "Negative Left"

FROM 
	peaks

;

-- 14. Positive and Negative RIGHT

SELECT
	peak_name
	,RIGHT(peak_name, 4) AS "Positive Right"
	,RIGHT(peak_name, -4) AS "Negative Right"

FROM 
	peaks

;

-- 15. Update iso_code
UPDATE
	countries
SET
	iso_code = UPPER(LEFT(country_name, 3))
WHERE
	iso_code is NULL
returning *;

-- 16. REVERSE country_code

UPDATE
	countries
SET
	country_code = LOWER(REVERSE(country_code))
RETURNING *;

-- 17. Elevation --->> Peak Name
SELECT
	CONCAT_WS(' ' 
		,"elevation"
		,REPEAT('-', 3) || REPEAT('>', 2)
		,"peak_name"
			 ) AS "Elevation --->> Peak Name"
FROM 
	peaks
WHERE
	elevation >= 4884;
	
	
-- 18. Arithmetical Operators
CREATE TABLE
	bookings_calculation
AS
SELECT
	booked_for
	,CAST(booked_for * 50 AS NUMERIC) AS "multiplication"
	,CAST(booked_for % 50 AS NUMERIC) AS "modulo"
FROM 
	bookings
WHERE
	apartment_id = 93;
	
-- 19.ROUND VS TRUNC
SELECT 
	latitude
	,ROUND(latitude, 2) AS "round"
	,TRUNC(latitude, 2) AS "trunc"
FROM 
	apartments;

-- 20. Absolute Value

SELECT 
	ABS(longitude) AS "abs"
FROM
	apartments
;

-- 21. Billing day

-- ALTER TABLE
-- 	bookings
-- ADD COLUMN
-- 	billing_day TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
-- ;
SELECT 
	billing_day
	,
	TO_CHAR(
		billing_day 
		,'DD "Day" MM "Month" YYYY "Year" HH24:MI:SS')
	AS "Billing Day"
FROM
	bookings
;

-- 22.Exctract booked_at

SELECT
	EXTRACT(YEAR FROM "booked_at")
		AS "YEAR"
	,EXTRACT(MONTH FROM "booked_at")
		AS "MONTH"
	,EXTRACT(DAY FROM "booked_at")
		AS "DAY"
	,EXTRACT(HOUR FROM "booked_at" AT TIME ZONE 'UTC')
		AS "HOUR"
	,EXTRACT(MINUTE FROM "booked_at")
		AS "MINUTE"
	,CEILING(EXTRACT(SECOND FROM "booked_at"))
		AS "SECOND"
	
FROM 
	bookings

-- 23. Early Birds
SELECT 
	user_id
	,AGE(starts_at, booked_at) AS "Early birds"
FROM
	bookings
WHERE 
	AGE(starts_at, booked_at) >= '10 MONTHS';
;

-- 24. Match or Not
SELECT
	companion_full_name
	,email
FROM
	users
WHERE
	companion_full_name ILIKE '%aNd%'
		AND
	email NOT LIKE '%gmail'
;

-- 25. * COUNT by Initial
SELECT
	LEFT(first_name, 2) AS "initials"
	,COUNT('initials') AS user_count
FROM 
	users
GROUP BY 
	initials
ORDER BY 
	user_count DESC
	,initials ASC
;

-- 26.SUM and 27.AVG

SELECT
	SUM(booked_for) AS total_value
FROM 
	bookings
WHERE
	apartment_id = 90
;

SELECT
	AVG(multiplication) AS "average_value"
FROM 
	bookings_calculation
;
