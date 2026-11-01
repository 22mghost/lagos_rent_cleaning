-- Check for duplicates 
SELECT *
FROM (SELECT *, ROW_NUMBER()OVER(PARTITION BY title, serviced, price, furnished, newly_built, bedrooms, bathrooms, toilets, city, neighbourhood) AS row_num
FROM lagos_staging ) AS row_table
WHERE row_num > 1;
-- 2780 Duplicates

SELECT * FROM lagos_staging
WHERE neighbourhood IS NULL;
-- 6 null neighbourhood, no null for other


SELECT * FROM lagos_raw
WHERE price = '1' OR price = '2' OR price = '0';

-- max and min prices
SELECT MAX(price), MIN(price)
FROM lagos_staging;
-- min price is zero max is 99,500/year, not clearly formatedd, the figure is faulty

SELECT title, TRIM(title)
FROM lagos_raw;



