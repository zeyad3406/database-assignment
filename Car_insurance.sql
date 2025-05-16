--problem a. Find the total number of people who owned cars that were involved in accidents in 2017.
SELECT COUNT(DISTINCT Owns.customerId)
FROM Owns, Accident
WHERE Owns.CarId = Accident.CarId
  AND Accident.Year = 2017;

--problem b. Find the number of accidents in which the cars belonging to Ahmed Mohamed were involved.
SELECT COUNT(*)
FROM Accident, Owns, Customer
WHERE Accident.CarId = Owns.CarId
  AND Owns.customerId = Customer.customerId
  AND Customer.first_Name = 'Ahmed'
  AND Customer.last_Name = 'Mohamed';
  --problem c. Find the model with maximum number of accidents in 2017.
SELECT Car.Model
FROM Car, Accident
WHERE Car.CarId = Accident.CarId
  AND Accident.Year = 2017
GROUP BY Car.Model
HAVING COUNT(*) = (
  SELECT MAX(accident_count)
  FROM (
    SELECT COUNT(*) accident_count
    FROM Car, Accident
    WHERE Car.CarId = Accident.CarId
      AND Accident.Year = 2017
    GROUP BY Car.Model
  )
);

--problem d. Car models with zero accidents
SELECT M.Model_id, M.Name
FROM Model M
WHERE M.Model_id NOT IN (
    SELECT DISTINCT C.Model_id
    FROM Car C
    JOIN Accident A ON C.Car_id = A.Car_id
);

--problem e. All customers with cars involved in accidents in a certain year
DECLARE @Year INT = 2024;

SELECT DISTINCT CU.Customer_id, CU.Name, CU.Phone, CU.Address
FROM Customer CU
JOIN Customer_Car CC ON CU.Customer_id = CC.Customer_id
JOIN Car C ON CC.Car_id = C.Car_id
JOIN Accident A ON C.Car_id = A.Car_id
WHERE YEAR(A.Date) = @Year;

-- f. Number of accidents involving cars of a specific model
DECLARE @ModelID INT = 101;

SELECT COUNT(*) AS Number_of_Accidents
FROM Accident A
JOIN Car C ON A.Car_id = C.Car_id
WHERE C.Model_id = @ModelID;
