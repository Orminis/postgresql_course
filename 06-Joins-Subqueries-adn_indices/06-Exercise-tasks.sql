-- 01.Booked for Nights
SELECT 
	CONCAT(a.address, ' ', a.address_2) AS "apartment_address"
	,b.booked_for AS "nights"
FROM 
	apartments AS a
JOIN 
	bookings AS b
ON 
	a.booking_id = b.booking_id
ORDER BY 
	a.apartment_id ASC
;

-- 02.First 10 Apartments Booked At
SELECT 
	a.name
	,a.country
	,b.booked_at::date
FROM
	apartments AS a
LEFT JOIN
	bookings AS b
ON
	a.booking_id = b.booking_id
LIMIT(10)
;

-- 03.First 10 Customers with Bookings
SELECT 
	b.booking_id
	,b.starts_at::date
	,b.apartment_id
	,CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM
	bookings AS b
RIGHT JOIN
	customers AS c
ON
	b.customer_id = c.customer_id
ORDER BY 
	customer_name
LIMIT(10)
;

-- 04.Booking Information 
SELECT 
	b.booking_id
	,a.name AS apartment_owner
	,a.apartment_id
	,CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM 
	apartments AS a
FULL JOIN 
	bookings AS b
ON 
	a.booking_id = b.booking_id
FULL JOIN 
	customers AS c
ON 
	b.customer_id = c.customer_id
ORDER BY
	b.booking_id ASC
	,apartment_owner ASC
	,customer_name ASC
;

-- 05. Multiplication of Information
SELECT 
	b.booking_id
	,c.first_name AS customer_name
FROM 
	bookings AS b
CROSS JOIN
	customers AS c
ORDER BY
	customer_name ASC
;

-- 06. Unassigned Apartments
SELECT 
	b.booking_id
	,b.apartment_id
	,c.companion_full_name 
FROM 
	bookings AS b
JOIN
	customers AS c
ON 
	b.customer_id = c.customer_id
WHERE 
	b.apartment_id is Null
;

-- 07. Bookings Made by Lead
SELECT 
	b.apartment_id
	,b.booked_for
	,c.first_name
	,c.country 
FROM 
	bookings AS b
INNER JOIN
	customers AS c
ON 
	b.customer_id = c.customer_id
WHERE
	c.job_type = 'Lead'
;

-- 08. Hahn's Bookings
SELECT 
	COUNT(*)
FROM 
	bookings AS b
JOIN
	customers AS c
ON 
	b.customer_id = c.customer_id
WHERE
	c.last_name = 'Hahn'
;

-- 09. Total Sum of Nights
SELECT 
	a.name
	,SUM(b.booked_for)
FROM 
	apartments AS a
JOIN
	bookings AS b
ON
	a.apartment_id = b.apartment_id
GROUP BY
	a.name
ORDER BY 
	a.name ASC
;

-- 10. Popular Vacation Destination
SELECT 
	a.country
	,count(b.booking_id) AS "booking_count"
FROM
	apartments AS a
JOIN
	bookings AS b
ON 
	a.apartment_id = b.apartment_id
WHERE
	 b.booked_at > '2021-05-18 07:52:09.904+03' 
	 and 
	 b.booked_at < '2021-09-17 19:48:02.147+03' 
GROUP BY
	a.country
ORDER BY
	"booking_count" DESC
;

-- 11. Bulgaria's Peaks Higher than 2835 Meters 
SELECT
	mc.country_code
	,m.mountain_range
	,p.peak_name
	,p.elevation
FROM
	mountains AS m
JOIN 
	mountains_countries AS mc
ON
	m.id = mc.mountain_id
JOIN
	peaks AS p
ON
	m.id = p.mountain_id
WHERE
	mc.country_code = 'BG'
	AND
	p.elevation > 2835
ORDER BY
	p.elevation DESC
;

-- 12. Count Mountain Ranges
SELECT
	mc.country_code
	,COUNT(m.mountain_range) AS "mountain_range_count"
FROM
	mountains AS m
JOIN 
	mountains_countries AS mc
ON
	m.id = mc.mountain_id
WHERE
	mc.country_code in ('BG', 'RU', 'US')
GROUP BY
	mc.country_code
ORDER BY 
	"mountain_range_count" DESC
;

-- 13. Rivers in Africa
SELECT
	c.country_name
	,r.river_name
FROM
	countries AS c
LEFT JOIN
	countries_rivers AS cr
ON 
	c.country_code = cr.country_code
LEFT JOIN
	rivers AS r
ON 
	cr.river_id = r.id
WHERE 
	continent_code = 'AF'
ORDER BY
	c.country_name
LIMIT 5
;

-- 14. Minimum Average Area Across Continents
SELECT
	AVG(area_in_sq_km) AS average_area
FROM
	countries
GROUP BY
	continent_code
ORDER BY
	average_area
LIMIT(1)
;

SELECT
	MIN(average_area_in_sq_km)
FROM (
	SELECT
		AVG(area_in_sq_km) AS average_area_in_sq_km
	FROM
		countries
	GROUP BY
		continent_code
) AS min_average_area
;

-- 15. Countries Without Any Mountains
SELECT 
	COUNT(*) AS "countries_without_mountains"	 
FROM 
	countries AS c
LEFT JOIN
	mountains_countries AS mc
ON
	c.country_code = mc.country_code
WHERE
	mc.mountain_id is Null
;

-- 16. Monasteries by Country
CREATE TABLE IF NOT EXISTS 
	monasteries(
		id SERIAL PRIMARY KEY
		,monastery_name VARCHAR(255)
		,country_code CHAR(2)
	)
;

INSERT INTO
	monasteries(monastery_name, country_code)
VALUES
	('Rila Monastery "St. Ivan of Rila"', 'BG'),
	('Bachkovo Monastery "Virgin Mary"', 'BG'),
	('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
	('Kopan Monastery', 'NP'),
	('Thrangu Tashi Yangtse Monastery', 'NP'),
	('Shechen Tennyi Dargyeling Monastery', 'NP'),
	('Benchen Monastery', 'NP'),
	('Southern Shaolin Monastery', 'CN'),
	('Dabei Monastery', 'CN'),
	('Wa Sau Toi', 'CN'),
	('Lhunshigyia Monastery', 'CN'),
	('Rakya Monastery', 'CN'),
	('Monasteries of Meteora', 'GR'),
	('The Holy Monastery of Stavronikita', 'GR'),
	('Taung Kalat Monastery', 'MM'),
	('Pa-Auk Forest Monastery', 'MM'),
	('Taktsang Palphug Monastery', 'BT'),
	('Sümela Monastery', 'TR')
;

ALTER TABLE 
	countries
ADD COLUMN 
	three_rivers BOOLEAN 
DEFAULT FALSE
;

UPDATE
	countries
SET
	three_rivers = (
		SELECT 
			COUNT(*) >= 3
		FROM 
			countries_rivers AS cr
		WHERE
			cr.country_code = countries.country_code
	)
;

SELECT 
	m.monastery_name
	,c.country_name
FROM
	monasteries AS m
JOIN 
	countries AS c
ON 
	m.country_code = c.country_code
WHERE
	NOT three_rivers
ORDER BY
	m.monastery_name ASC
;


-- 17
UPDATE
	countries
SET
	country_name = 'Burma'
WHERE
	country_name = 'Myanmar'
;

INSERT INTO
	monasteries(monastery_name, country_code)
VALUES
	('Hanga Abbey', 'TZ')
	,('Myin-Tin-Daik', 'MM')
;

SELECT 
	cont.continent_name
	,c.country_name
	,COUNT(m.monastery_name) AS monastery_count
FROM
	continents AS cont
JOIN
	countries AS c
USING
	(continent_code)
LEFT JOIN 
	monasteries AS m
ON
	c.country_code = m.country_code
WHERE
	NOT c.three_rivers
GROUP BY 
	cont.continent_name
	,c.country_name
	
ORDER BY
	monastery_count DESC
	,c.country_name ASC
;

-- 18. Retrieving Information about Indexes
SELECT
	tablename
	,indexname
	,indexdef
FROM
	pg_indexes
WHERE
	schemaname = 'public'
ORDER BY
	tablename ASC
	,indexname ASC
;

-- 19. * Continents and Currencies
CREATE VIEW 
	continent_currency_usage 
AS

SELECT
	final_table.continent_code
	,final_table.currency_code
	,final_table.currency_usage

FROM
(
	SELECT 
		counted_table.continent_code
		,counted_table.currency_code
		,counted_table.currency_usage
		,DENSE_RANK() OVER (PARTITION BY counted_table.continent_code ORDER BY counted_table.currency_usage DESC) AS "dense_rank"
	
	FROM (
		SELECT
			continent_code
			,currency_code
			,count(currency_code) as currency_usage
		FROM 
			countries	
		GROUP BY
			continent_code
			,currency_code
		HAVING
			COUNT(*) > 1
		) AS counted_table

) AS final_table

WHERE 
	final_table.dense_rank = 1
ORDER BY 
	final_table.currency_usage DESC
;

-- 20
WITH 
	"row_number" as(
		SELECT
			c.country_name
			,COALESCE(p.peak_name, '(no highest peak)') as highest_peak_name
			,COALESCE(p.elevation, 0) AS highest_peak_elevation
			,COALESCE(m.mountain_range, '(no mountain)') as mountain
			,ROW_NUMBER() OVER (PARTITION BY c.country_name ORDER BY p.elevation DESC) AS row_nums


		FROM
			countries AS c
		
		LEFT JOIN mountains_countries as mc
			ON c.country_code = mc.country_code
		
		LEFT JOIN peaks as p
			ON mc.mountain_id = p.mountain_id
		
		LEFT JOIN mountains as m
			on m.id = p.mountain_id
	)
SELECT
	country_name
	,highest_peak_name
	,highest_peak_elevation
	,mountain
FROM 
	"row_number"
WHERE 
	row_nums = 1
ORDER BY
	country_name ASC
	,highest_peak_elevation DESC
;