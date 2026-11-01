-- IMPORTING DATA
LOAD DATA LOCAL INFILE 'cfafrica-_-openafrica-_-reform-_-current-requests-a1.csv'
INTO TABLE lagos_raw
CHARACTER SET latin1 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(title, more_info, price, serviced, newly_built, furnished, bedrooms, bathrooms, toilets, city, neighbourhood);

SHOW WARNINGS; -- To check for errors

SELECT * FROM lagos_raw; -- Shoe all Data

SELECT COUNT(*) FROM lagos_raw; -- To check if the imported data is equal to source

CREATE TABLE lagos_staging LIKE lagos_raw; -- To create a staging table
INSERT INTO lagos_staging SELECT * FROM lagos_raw; -- insert all raw data into staging table
