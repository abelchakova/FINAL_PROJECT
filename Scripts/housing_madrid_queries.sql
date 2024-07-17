USE real_estate;

-- Retrieve All Properties in a Specific District
SELECT nhm.id, nhm.sq_m, nhm.rooms, nhm.bathrooms, nhm.price, n.neighborhood, d.district
FROM new_housing_madrid nhm
JOIN neighborhood n ON nhm.neighborhood_id = n.id
JOIN district d ON n.district_id = d.id
WHERE d.district = 'Villaverde';

-- Calculate the Average Price per Square Meter by District
SELECT d.district, ROUND(AVG(nhm.price / nhm.sq_m), 2) AS avg_price_per_sqm
FROM new_housing_madrid nhm
JOIN neighborhood n ON nhm.neighborhood_id = n.id
JOIN district d ON n.district_id = d.id
GROUP BY d.district
ORDER BY avg_price_per_sqm DESC;

-- Get Average Property Price and Count by House Type
SELECT ht.house_type, 
       COUNT(*) AS num_properties, 
       ROUND(AVG(nhm.price), 2) AS avg_price
FROM new_housing_madrid nhm
JOIN house_type ht ON nhm.house_type_id = ht.id
GROUP BY ht.house_type
ORDER BY avg_price DESC;

-- Count the Number of Properties with Specific Features
SELECT 
    COUNT(*) AS total_properties,
    SUM(has_garden) AS properties_with_garden,
    SUM(has_pool) AS properties_with_pool,
    SUM(has_terrace) AS properties_with_terrace
FROM new_housing_madrid;


