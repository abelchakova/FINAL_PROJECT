-- Create Schema
CREATE SCHEMA IF NOT EXISTS real_estate;

-- Drop tables if they exist
DROP TABLE IF EXISTS new_housing_madrid;
DROP TABLE IF EXISTS neighborhood;
DROP TABLE IF EXISTS district;
DROP TABLE IF EXISTS house_type;

-- Create district table
CREATE TABLE district (
    id INT PRIMARY KEY AUTO_INCREMENT,
    district VARCHAR(100) UNIQUE NOT NULL
);

-- Create neighborhood table
CREATE TABLE neighborhood (
    id INT PRIMARY KEY AUTO_INCREMENT,
    neighborhood VARCHAR(100) UNIQUE NOT NULL,
    district_id INT,
    FOREIGN KEY (district_id) REFERENCES district(id)
);

-- Create house_type table
CREATE TABLE house_type (
    id INT PRIMARY KEY AUTO_INCREMENT,
    house_type VARCHAR(50) UNIQUE NOT NULL
);

-- Create new housing_madrid table
CREATE TABLE new_housing_madrid (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sq_m FLOAT,
    rooms INT,
    bathrooms INT,
    floors INT,
    sq_m_allotment FLOAT,
    floor INT,
    neighborhood_id INT,
    price FLOAT,
    house_type_id INT,
    is_renewal_needed BOOLEAN,
    has_ac BOOLEAN,
    has_fitted_wardrobes BOOLEAN,
    has_lift BOOLEAN,
    has_garden BOOLEAN,
    has_pool BOOLEAN,
    has_terrace BOOLEAN,
    has_balcony BOOLEAN,
    has_storage_room BOOLEAN,
    has_green_zones BOOLEAN,
    has_parking BOOLEAN,
    parking_included BOOLEAN,
    parking_price FLOAT,
    orientation_north BOOLEAN,
    orientation_west BOOLEAN,
    orientation_south BOOLEAN,
    orientation_east BOOLEAN,
    FOREIGN KEY (neighborhood_id) REFERENCES neighborhood(id),
    FOREIGN KEY (house_type_id) REFERENCES house_type(id)
);

-- Populate district table
INSERT IGNORE INTO district (district)
SELECT DISTINCT district FROM housing_madrid;

-- Populate neighborhood table
INSERT IGNORE INTO neighborhood (neighborhood, district_id)
SELECT DISTINCT hm.neighborhood, d.id
FROM housing_madrid hm
JOIN district d ON hm.district = d.district;

-- Populate house_type table
INSERT IGNORE INTO house_type (house_type)
SELECT DISTINCT house_type FROM housing_madrid;

-- Populate new_housing_madrid table
INSERT INTO new_housing_madrid (
    sq_m, rooms, bathrooms, floors, sq_m_allotment, floor,
    neighborhood_id, price, house_type_id, is_renewal_needed,
    has_ac, has_fitted_wardrobes, has_lift, has_garden, has_pool, has_terrace,
    has_balcony, has_storage_room, has_green_zones, has_parking,
    parking_included, parking_price, orientation_north,
    orientation_west, orientation_south, orientation_east
)
SELECT 
    hm.sq_m, hm.rooms, hm.bathrooms, hm.floors, hm.sq_m_allotment, hm.floor,
    n.id AS neighborhood_id, hm.price, ht.id AS house_type_id, hm.is_renewal_needed,
    hm.has_ac, hm.has_fitted_wardrobes, hm.has_lift, hm.has_garden, hm.has_pool, hm.has_terrace,
    hm.has_balcony, hm.has_storage_room, hm.has_green_zones, hm.has_parking,
    hm.parking_included, hm.parking_price, hm.orientation_north,
    hm.orientation_west, hm.orientation_south, hm.orientation_east
FROM housing_madrid hm
JOIN neighborhood n ON hm.neighborhood = n.neighborhood
JOIN house_type ht ON hm.house_type = ht.house_type;
