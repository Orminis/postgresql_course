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
	,count(*) AS "booking_count"
FROM
	apartments AS a
JOIN
	bookings AS b
ON 
	a.apartment_id = b.apartment_id
WHERE
	 b.booked_at >='2021-05-18 07:52:09.904+03' 
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
	,COUNT(*) AS "mountain_range_count"
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
on 
	cr.river_id = r.id
WHERE 
	continent_code = 'AF'
ORDER BY
	c.country_name
LIMIT(5)
;