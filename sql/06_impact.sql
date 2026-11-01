-- row count, number of distinct locations, average price, rows missing price, and the highest price.
-- one headline sentence

SELECT COUNT(*) as raw_rows,
(SELECT COUNT(*) FROM lagos_staging) AS staging_rows,
COUNT(DISTINCT city) AS raw_distinct_city,
(SELECT COUNT(DISTINCT city) FROM lagos_staging) AS staging_distinct_city
FROM lagos_raw;

SELECT DISTINCT city from lagos_staging;

SELECT AVG(price) FROM lagos_staging; -- '4069170.1541'
SELECT MAX(price) FROM lagos_staging; -- '150000000'
SELECT MIN(price) FROM lagos_staging;

SELECT * from lagos_staging;