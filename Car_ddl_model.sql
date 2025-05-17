CREATE DATABASE CarInsuranceSystem;
USE CarInsuranceSystem;

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
SELECT * FROM users;
SELECT * FROM customers;
SELECT * FROM accidents;
SELECT * FROM cars;
