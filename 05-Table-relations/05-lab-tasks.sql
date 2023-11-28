-- 01.Mountains and Peaks
CREATE TABLE mountains(
	"id" SERIAL PRIMARY KEY
	,"name" VARCHAR(50)
)
;

CREATE TABLE peaks(
	"id" SERIAL PRIMARY KEY
	,"name" VARCHAR(50)
	,"mountain_id" INT
	
	,CONSTRAINT fk_peaks_mountains
		FOREIGN KEY	("mountain_id")
			REFERENCES mountains(id)
)
;

-- How to add Foreign Key at later stage
ALTER TABLE peaks
ADD CONSTRAINT fk_peaks_mountains
	FOREIGN KEY (mountain_id)
		REFERENCES mountains(id)
;

-- 02.Trip Organization
SELECT 
	v.driver_id
	,v.vehicle_type
	,CONCAT(c.first_name, ' ', c.last_name)
FROM
	vehicles as v 
		JOIN campers as c
			ON v.driver_id = c.id
;

-- 03.SoftUni Hiking
SELECT
	r.start_point
	,r.end_point
	,r.leader_id
	,CONCAT(c.first_name, ' ', c.last_name) AS "leader_name"
FROM
	routes as r
		JOIN campers as c
			ON r.leader_id = c.id
;

-- 04.Delete Mountains
DROP TABLE peaks;
DROP TABLE mountains;

CREATE TABLE mountains(
	id SERIAL PRIMARY KEY
	,"name" VARCHAR(50)
)
;
CREATE TABLE peaks(
	id SERIAL PRIMARY KEY
	,"name" VARCHAR(50)
	,mountain_id INT
	
	,CONSTRAINT fk_mountain_id
		FOREIGN KEY ("mountain_id")
			REFERENCES mountains("id")
				ON DELETE CASCADE 
)
;