CREATE DATABASE CarInsuranceSystem2;
USE CarInsuranceSystem2;

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Customers table
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(20) NOT NULL,
    address VARCHAR(20) NOT NULL,
);

-- Cars table, linked to customers
CREATE TABLE cars (
    car_id INT PRIMARY KEY IDENTITY(1,1),
    plate VARCHAR(20) UNIQUE NOT NULL,
    model VARCHAR(255) NOT NULL,
    year INT,
    status BIT, -- 1 for insured, 0 for not
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);


-- Accidents table, linked to cars
CREATE TABLE accidents (
    id VARCHAR(50) PRIMARY KEY,
    car_plate VARCHAR(20) NOT NULL,
    damage_Cost DECIMAL(20) NOT NULL,
    description VARCHAR(MAX) NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (car_plate) REFERENCES cars(plate) ON DELETE CASCADE
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
    Month VARCHAR(10) NOT NULL,             
    totalAccidents INT NOT NULL,             
    generatedDate DATE NOT NULL,            
    generatedBy VARCHAR(50) NOT NULL         
);

CREATE TABLE driver_licenses (
    customer_id INT,                 -- FK from customers
    license_number VARCHAR(50),              -- Part of PK, e.g., 'DL12345678'
    issue_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    license_type VARCHAR(30),                -- e.g., 'Private', 'Commercial'

    PRIMARY KEY (customer_id, license_number),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);


SELECT * FROM users;
SELECT * FROM customers;
SELECT * FROM accidents;
SELECT * FROM monthly_reports;
SELECT * FROM insurance_policies;
SELECT * FROM cars;
SELECT * FROM driver_licenses;



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









-- USERS
INSERT INTO users (username, password)
VALUES 
('admin', 'admin123'),
('user1', 'pass1'),
('user2', 'pass2');


-- CUSTOMERS
INSERT INTO customers (id, name, phone, email, address)
VALUES 
(1, 'Ahmed Mohamed', '123456789', 'ahmed@example.com', '123 Main St'),
(2, 'Fatima Noor', '987654321', 'fatima@example.com', '456 Park Ave'),
(3, 'John Doe', '555666777', 'john@example.com', '789 Elm Rd'),
(4, 'Ali Hassan', '111222333', 'ali@example.com', '321 Oak St');


-- CARS
INSERT INTO cars (plate, model, year, status, customer_id)
VALUES 
('ABC123', 'Toyota Corolla', 2015, 1, 1),
('XYZ789', 'Honda Civic', 2018, 1, 2),
('DEF456', 'Toyota Corolla', 2017, 1, 3),
('LMN321', 'Ford Focus', 2019, 1, 4),
('GHJ567', 'Hyundai Elantra', 2020, 1, 1);


-- ACCIDENTS
INSERT INTO accidents (id, car_plate, damage_cost, description, date)
VALUES 
('A001', 'ABC123', 1500.00, 'Minor rear-end collision', '2017-05-10'),
('A002', 'DEF456', 7000.00, 'Hit and run', '2017-08-12'),
('A003', 'XYZ789', 1200.00, 'Side swipe', '2018-03-14'),
('A004', 'GHJ567', 2300.00, 'Fender bender', '2024-01-11'),
('A005', 'DEF456', 5500.00, 'T-bone accident', '2017-11-22'),
('A006', 'XYZ789', 900.00, 'Glass damage', '2024-02-17');



-- INSURANCE_POLICIES
INSERT INTO insurance_policies (policy_id, start_date, end_date, coverage_type, premium_amount)
VALUES 
('POL001', '2024-01-01', '2025-01-01', 'Comprehensive', 1200.00),
('POL002', '2024-06-01', '2025-06-01', 'Third Party', 750.00),
('POL003', '2024-03-15', '2025-03-15', 'Comprehensive', 980.50);


-- MONTHLY_REPORTS
INSERT INTO monthly_reports (Month, totalAccidents, generatedDate, generatedBy)
VALUES 
('2024-05', 12, GETDATE(), 'AdminUser1');

INSERT INTO driver_licenses (customer_id, license_number, issue_date, expiry_date, license_type)
VALUES
(1, 'DL100001', '2018-01-15', '2028-01-15', 'Private'),
(1, 'DL100002', '2020-06-10', '2030-06-10', 'Commercial'),
(2, 'DL200001', '2019-03-20', '2029-03-20', 'Private'),
(3, 'DL300001', '2017-11-05', '2027-11-05', 'Private'),
(4, 'DL400001', '2021-07-01', '2031-07-01', 'Commercial');
