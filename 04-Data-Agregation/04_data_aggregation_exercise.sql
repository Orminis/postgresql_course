-- 01. COUNT of Records 
SELECT 
	COUNT(*)
FROM
	wizard_deposits
;

-- 02. Total Deposit Amount

SELECT
	SUM(wd.deposit_amount) AS "Total Amount"
FROM
	wizard_deposits AS wd
;

-- 03. AVG Magic Wand Size
SELECT
	ROUND(AVG(wd.magic_wand_size)::numeric, 3) AS "Average Magic Wand Size"
FROM
	wizard_deposits AS wd
;
	
-- 04. MIN Deposit Charge

SELECT 
	MIN(deposit_charge) AS "Minimum Deposit Charge"
FROM
	wizard_deposits
;

-- 05. MAX Age

SELECT 
	MAX(wd.age)
FROM 
	wizard_deposits AS wd
;

-- 06. GROUP BY Deposit Interest

SELECT 
	wd.deposit_group
	,SUM(wd.deposit_interest) AS "Deposit Interest"
FROM
	wizard_deposits AS wd
GROUP BY
	wd.deposit_group
ORDER BY 
	"Deposit Interest" DESC
;
	
-- 07. LIMIT the Magic Wand Creator

SELECT 
	wd.magic_wand_creator
	,MIN(wd.magic_wand_size) AS "Minimum Wand Size"
FROM
	wizard_deposits AS wd
GROUP BY
	wd.magic_wand_creator
ORDER BY "Minimum Wand Size" ASC
LIMIT 5
;


-- 08. Bank Profitability

SELECT 
	wd.deposit_group
	,wd.is_deposit_expired
	,TRUNC(AVG(wd.deposit_interest)) AS "Deposit Interest"
	
FROM
	wizard_deposits AS wd
WHERE
	wd.deposit_start_date >= '1985-01-01'

GROUP BY 
	wd.deposit_group
	,wd.is_deposit_expired
ORDER BY
	wd.deposit_group DESC
	,wd.is_deposit_expired ASC
;

-- 09. Notes with Dumbledore

SELECT 
	wd.last_name
	,COUNT(wd.notes LIKE '%Dumbledore%') AS "Notes with Dumbledore"
FROM 
	wizard_deposits AS wd
WHERE 
	wd.notes LIKE '%Dumbledore%'
GROUP BY 
	wd.last_name
;

-- 10. Wizard View
CREATE VIEW 
	"view_wizard_deposits_with_expiration_date_before_1983_08_17"
AS

SELECT
	CONCAT("first_name", ' ', "last_name") AS "Wizard Name"
	,deposit_start_date AS "Start Date"
	,deposit_expiration_date AS "Expiration Date"
	,deposit_amount AS "Amount"
FROM
	wizard_deposits

WHERE
	deposit_expiration_date <= '1983-08-17'
	
GROUP BY 
	"Wizard Name"
	,"Start Date"
	,"Expiration Date"
	,"Amount"

ORDER BY 
	deposit_expiration_date ASC
;

-- 11. Filter Max Deposit

SELECT
	magic_wand_creator
	,MAX(deposit_amount) AS "Max Deposit Amount"
FROM
	wizard_deposits
	
GROUP BY 
	magic_wand_creator
HAVING
	MAX(deposit_amount) < 20000 
	OR MAX(deposit_amount) > 40000
ORDER BY 
	"Max Deposit Amount" DESC
LIMIT 3
;

-- 12. Age Group

SELECT 
	CASE
		WHEN age <= 10 THEN '[0-10]'
		WHEN age > 10 AND age <= 20  THEN '[11-20]'
		WHEN age > 20 AND age <= 30  THEN '[21-30]'
		WHEN age > 30 AND age <= 40  THEN '[31-40]'
		WHEN age > 40 AND age <= 50  THEN '[41-50]'
		WHEN age > 50 AND age <= 60  THEN '[51-60]'
		WHEN age > 60 THEN '[61+]'		
	END AS "Age Group"
	,COUNT('Age Group') AS "count"
FROM
	wizard_deposits
GROUP BY 
	"Age Group"
ORDER BY
	"Age Group"
;

--