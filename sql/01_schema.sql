CREATE DATABASE IF NOT EXISTS lagos_rent_cleaning;
USE lagos_rent_cleaning;

DROP TABLE IF EXISTS lagos_raw;
CREATE TABLE lagos_raw (
    raw_id       INT AUTO_INCREMENT PRIMARY KEY,
    title  VARCHAR(255),
    more_info   VARCHAR(255),
    price  VARCHAR(255),
    serviced     VARCHAR(32),
    newly_built VARCHAR(32),
    furnished   VARCHAR(32),
    bedrooms  VARCHAR(255),
    bathrooms      VARCHAR(255),
    toilets VARCHAR(255),
    city  VARCHAR(32),
    neighbourhood  VARCHAR(32)
);

DESCRIBE lagos_raw;