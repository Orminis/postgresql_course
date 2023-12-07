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
