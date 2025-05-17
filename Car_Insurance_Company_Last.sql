CREATE DATABASE CarInsuranceSystem;
USE CarInsuranceSystem;
DROP DATABASE koko;
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Customers table
CREATE TABLE customers (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- Cars table, linked to customers
CREATE TABLE cars (
    plate VARCHAR(20) PRIMARY KEY,
    model VARCHAR(255) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- Accidents table, linked to cars
CREATE TABLE accidents (
    id VARCHAR(50) PRIMARY KEY,
    car_plate VARCHAR(20) NOT NULL,
    description VARCHAR(MAX) NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (car_plate) REFERENCES cars(plate) ON DELETE CASCADE
);
CREATE TABLE accident_participants (
    accident_id VARCHAR(50) NOT NULL,
    car_plate VARCHAR(20) NOT NULL,
    role VARCHAR(100),         -- Optional
    damage_level VARCHAR(50),  -- Optional
    PRIMARY KEY (accident_id, car_plate),
    FOREIGN KEY (accident_id) REFERENCES accidents(id) ON DELETE CASCADE,
    FOREIGN KEY (car_plate) REFERENCES cars(plate) ON DELETE NO ACTION
);
CREATE TABLE insurance_policies (
    policy_id VARCHAR(50) PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    coverage_type VARCHAR(100) NOT NULL,
    premium_amount DECIMAL(10, 2) NOT NULL
);


CREATE TABLE monthly_reports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    Month VARCHAR(10) NOT NULL,              -- e.g., '2024-05'
    totalAccidents INT NOT NULL,             -- number of accidents reported in that month
    generatedDate DATE NOT NULL,             -- when the report was generated
    generatedBy VARCHAR(50) NOT NULL         -- name or ID of the staff who generated it
);

SELECT * FROM users;
SELECT * FROM customers;
SELECT * FROM accidents;
SELECT * FROM monthly_reports;

SELECT * FROM insurance_policies;
SELECT * FROM cars;



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







INSERT INTO users (username, password)
VALUES 
('admin', 'admin123'),
('user1', 'pass1'),
('user2', 'pass2');


INSERT INTO customers (id, name, phone)
VALUES 
('C001', 'Ahmed Mohamed', '123456789'),
('C002', 'Fatima Noor', '987654321'),
('C003', 'John Doe', '555666777'),
('C004', 'Ali Hassan', '111222333');


INSERT INTO cars (plate, model, customer_id)
VALUES 
('ABC123', 'Toyota Corolla', 'C001'),
('XYZ789', 'Honda Civic', 'C002'),
('DEF456', 'Toyota Corolla', 'C003'),
('LMN321', 'Ford Focus', 'C004'),
('GHJ567', 'Hyundai Elantra', 'C001');


INSERT INTO accidents (id, car_plate, description, date)
VALUES 
('A001', 'ABC123', 'Minor rear-end collision', '2017-05-10'),
('A002', 'DEF456', 'Hit and run', '2017-08-12'),
('A003', 'XYZ789', 'Side swipe', '2018-03-14'),
('A004', 'GHJ567', 'Fender bender', '2024-01-11'),
('A005', 'DEF456', 'T-bone accident', '2017-11-22'),
('A006', 'XYZ789', 'Glass damage', '2024-02-17');

INSERT INTO accident_participants (accident_id, car_plate, role, damage_level)
VALUES 
-- Accident A001 involved one car
('A001', 'ABC123', 'victim', 'minor'),

-- Accident A002 involved multiple cars
('A002', 'ABC123', 'at fault', 'major'),
('A002', 'DEF456', 'victim', 'moderate'),
('A002', 'XYZ789', 'witness', 'none'),

-- Accident A003 involved one car
('A003', 'XYZ789', 'at fault', 'minor');

INSERT INTO insurance_policies (policy_id, start_date, end_date, coverage_type, premium_amount)
VALUES 
('POL001', '2024-01-01', '2025-01-01', 'Comprehensive', 1200.00),
('POL002', '2024-06-01', '2025-06-01', 'Third Party', 750.00),
('POL003', '2024-03-15', '2025-03-15', 'Comprehensive', 980.50);
   


INSERT INTO monthly_reports (Month, totalAccidents, generatedDate, generatedBy)
VALUES ('2024-05', 12, GETDATE(), 'AdminUser1');
