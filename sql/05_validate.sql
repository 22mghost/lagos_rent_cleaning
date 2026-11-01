SELECT COUNT(*)
FROM lagos_staging; -- 49411 rows

SELECT COUNT(*)
FROM lagos_rejects; -- 3457

SELECT count(*) raw_rows, (SELECT COUNT(*)
FROM lagos_rejects) rejects_rows, (SELECT COUNT(*)
FROM lagos_staging) clean_rows
FROM lagos_raw; 



SELECT lraw.raw_id, lstg.title, lstg.serviced, lraw.serviced, lraw.price, lstg.price, lraw.city
FROM lagos_staging lstg
JOIN lagos_raw  lraw
ON lstg.raw_id = lraw.raw_id
LIMIT 20;
