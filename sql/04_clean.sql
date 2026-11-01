
UPDATE lagos_staging
SET title = TRIM(title); -- trimming the title

UPDATE lagos_staging
SET title = REPLACE(REPLACE(title, '?', ''), '*', '')
WHERE title LIKE '%?%' OR title LIKE '%*%';

UPDATE lagos_staging
SET price = REGEXP_REPLACE(price, '[^ 0-9]', '');

select price, raw_id, length(price)
from lagos_staging
where raw_id = 5451;

ALTER TABLE lagos_staging
MODIFY COLUMN price DECIMAL (15, 0);


-- In lagos a house rent cant be greater than 150 million
-- Clean inplausible prices
select price, raw_id, length(price), flag
from lagos_staging
where flag = 'Implausible';

SELECT *,
CASE
	WHEN price <= 150000000 THEN 'Plausible'
    WHEN price > 150000000 THEN 'Implausible'
END AS flag
FROM lagos_staging;

ALTER TABLE lagos_staging
ADD flag VARCHAR(255); 

UPDATE lagos_staging
SET flag = CASE
	WHEN price <= 150000000 THEN 'Plausible'
    WHEN price > 150000000 THEN 'Implausible'
END;

DELETE 
FROM lagos_staging
WHERE price > 150000000;

select price, raw_id, length(price), flag
from lagos_staging
where flag = 'Implausible';

-- Handling duplicates
CREATE TABLE lagos_rejects LIKE lagos_staging;
DESCRIBE lagos_rejects;

ALTER TABLE lagos_rejects
ADD reason VARCHAR(225); 

-- inserting the duplicate into the reject table
INSERT INTO lagos_rejects (title, more_info, price, serviced, newly_built, furnished, bedrooms, bathrooms, toilets, city, neighbourhood, reason)
SELECT title, more_info, price, serviced, newly_built, furnished, bedrooms, bathrooms, toilets, city, neighbourhood, reason
FROM (SELECT *,
ROW_NUMBER()OVER(PARTITION BY title, serviced, price, furnished, newly_built, bedrooms, bathrooms, toilets, city, neighbourhood) AS row_num,
'Duplicates' AS reason
FROM lagos_staging ) AS row_table
WHERE row_num > 1;

-- Delete the duplicate rows from the original table
DELETE FROM lagos_staging
WHERE raw_id IN (
    SELECT raw_id
    FROM (
        SELECT raw_id,
               ROW_NUMBER() OVER(
                   PARTITION BY title, serviced, price, newly_built, bedrooms, bathrooms, toilets, city, neighbourhood 
                   ORDER BY raw_id 
               ) AS row_num
        FROM lagos_staging
    ) AS row_table
    WHERE row_num > 1
);


INSERT INTO lagos_rejects (title, more_info, price, serviced, newly_built, furnished, bedrooms, bathrooms, toilets, city, neighbourhood)
SELECT title, more_info, price, serviced, newly_built, furnished, bedrooms, bathrooms, toilets, city, neighbourhood
FROM lagos_staging
WHERE price = '0' OR '1' OR '2';

DELETE FROM lagos_rejects
WHERE price = '0' OR price = '1';


-- Rejecting null and blank data
DELETE FROM lagos_staging
WHERE neighbourhood IS NULL OR neighbourhood = '';

 
-- turn serviced, newly_built, furnished into 1 or 0
SELECT raw_id FROM lagos_staging WHERE serviced != '1' AND serviced != '0'; -- NULL

SELECT serviced, CASE
					WHEN serviced = 0 then 'No'
                    WHEN serviced = 1 THEN 'Yes'
END AS new_service
FROM lagos_staging;

UPDATE lagos_staging
SET serviced = CASE
					WHEN serviced = 0 then 'No'
                    WHEN serviced = 1 THEN 'Yes'
END;  -- changing the serviced column into yes or no

UPDATE lagos_staging
SET 
furnished = CASE
					WHEN furnished = 0 then 'No'
                    WHEN furnished = 1 THEN 'Yes'
END,
newly_built = CASE
					WHEN newly_built = 0 then 'No'
                    WHEN newly_built = 1 THEN 'Yes'
END;  -- changing the furnished and newly built column into yes or no

select * from lagos_staging
limit 100;

describe lagos_staging;
