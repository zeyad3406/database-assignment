--problem A. Total number of people who owned cars involved in accidents in 2017
SELECT COUNT(DISTINCT cars.customer_id)
FROM cars, accidents
WHERE cars.plate = accidents.car_plate
  AND YEAR(accidents.date) = 2017;

--problem B. Number of accidents for cars owned by Ahmed Mohamed
SELECT COUNT(*)
FROM accidents, cars, customers
WHERE accidents.car_plate = cars.plate
  AND cars.customer_id = customers.id
  AND customers.name = 'Ahmed Mohamed';

--problem C. Model with max accidents in 2017
SELECT cars.model
FROM cars, accidents
WHERE cars.plate = accidents.car_plate
  AND YEAR(accidents.date) = 2017
GROUP BY cars.model
HAVING COUNT(*) = (
  SELECT MAX(accident_count)
  FROM (
    SELECT COUNT(*) accident_count
    FROM cars, accidents
    WHERE cars.plate = accidents.car_plate
      AND YEAR(accidents.date) = 2017
    GROUP BY cars.model
  ) AS sub
);

--problem D. Car models with zero accidents
SELECT DISTINCT cars.model
FROM cars
WHERE cars.model NOT IN (
    SELECT DISTINCT c.model
    FROM cars c
    JOIN accidents a ON c.plate = a.car_plate
);

--problem E. Customers with cars in accidents in a certain year
DECLARE @Year INT = 2024;

SELECT DISTINCT customers.id, customers.name, customers.phone
FROM customers
JOIN cars ON customers.id = cars.customer_id
JOIN accidents ON cars.plate = accidents.car_plate
WHERE YEAR(accidents.date) = @Year;

--problem F. Number of accidents for a specific model
DECLARE @Model VARCHAR(255) = 'Toyota Corolla';

SELECT COUNT(*) AS Number_of_Accidents
FROM accidents a
JOIN cars c ON a.car_plate = c.plate
WHERE c.model = @Model;
