-- d. Car models with zero accidents
SELECT M.Model_id, M.Name
FROM Model M
WHERE M.Model_id NOT IN (
    SELECT DISTINCT C.Model_id
    FROM Car C
    JOIN Accident A ON C.Car_id = A.Car_id
);

-- e. All customers with cars involved in accidents in a certain year
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
