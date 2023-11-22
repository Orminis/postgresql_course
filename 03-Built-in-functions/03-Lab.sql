docker exec -it <container_name> psql -U <user_name> -W <project_to_be_connected>



concat()
concatws()
substring
left
right
replace
trim
lower
upper
reverse
repeat
length
char_length
bit_length

translate
initcap to check
position



```
SELECT
	full_name
	,LEFT(full_name, POSITION(' ' in full_name) AS first_name
	,RIGHT(full_name, LENGTH(full_name) - POSITION(' ' in full_name) AS last_name
	,SUBSTRING(full_name, 1, position(' ' in full_name) AS first_name
	,SUBSTRING(full_name, POSITION(' ' in full_name, length(full_name)) AS last_name
FROM
	`some_table`
```

```
cast()

SELECT
	CAST(5 as float) / 2
	-- same as 
	-- 5::float / 2
```


-- 01
-- SELECT 
-- 	title
-- FROM 
-- 	books
-- WHERE 
-- 	SUBSTRING(title, 1, 3) = 'The'

-- -- Another solutions
-- --	title LIKE 'The%' 
--
-- -- 	LEFT(title, 3) = 'The'

-- ORDER BY 
-- 	"id"
-- ;


SELECT
	title
FROM
	books
WHERE
;

-- 02
SELECT
REPLACE(
	b.title, 'The', '***') AS "Title"
FROM
	books AS b
WHERE
	SUBSTRING(b.title, 1, 3) = 'The'
	-- LEFT(b.title, 3) = 'The'
ORDER BY id
;

-- 03
SELECT 
	id
	,(side * height)/2 AS area 
FROM 
	triangles AS t
ORDER BY 
	id;
	
-- 04 Format Costs
SELECT 
	title
	,round(cost, 3) AS modified_price
FROM books AS b
ORDER BY id
;

-- 05
SELECT 
	first_name
	,last_name
	,extract(year from a.born) AS year
	-- to_char(born, 'YYYY') AS year
FROM authors AS a
ORDER BY id
;

SELECT
	AGE(a.died, a.born) as "age"
from authors as a
ORDER BY id;

SELECT 
	NOW()
	,CURRENT_DATE
	,CURRENT_TIME
	TO_CHAR(
		NOW(), 'YYYY Month DD'
		) AS "DATE"
;



-- 06
SELECT 
	a.last_name AS "Last Name"
	,to_char(a.born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
FROM 
	authors AS a
ORDER BY a.id
;

-- 07
SELECT 
	title
FROM
	books AS b
WHERE
	title
	LIKE '%Harry Potter%'
ORDER BY id;

--
SELECT 
	title
FROM 
	books
WHERE 
	SUBSTRING(title, 1, 5) = 'Harry'

ORDER BY 
	"id"
;