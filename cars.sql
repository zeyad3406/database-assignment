-- Users table
CREATE TABLE SystemUser (
    Name NVARCHAR(50) PRIMARY KEY,
    Password NVARCHAR(50),
    Role NVARCHAR(50) CHECK (Role IN ('Admin', 'User'))
);

-- Customers table
CREATE TABLE Customers (
    CustomerID NVARCHAR(50) PRIMARY KEY,
    Name NVARCHAR(100),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(255)
);

-- Cars table
CREATE TABLE Cars (
    Plate NVARCHAR(20) PRIMARY KEY,
    Model NVARCHAR(100),
    CarID NVARCHAR(50),
    CustomerID NVARCHAR(50),
    Status NVARCHAR(20) CHECK (Status IN ('Active', 'Inactive')),
    LicenseExpiry DATE,
    LicenseNumber NVARCHAR(50),
    LicenseIssueDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Accidents table
CREATE TABLE Accidents (
    AccidentID NVARCHAR(50) PRIMARY KEY,
    AccidentLocation NVARCHAR(255),
    CarID NVARCHAR(50),
    Plate NVARCHAR(20),
    Year NVARCHAR(4),
    DamageCost DECIMAL(10, 2),    
    AccidentInformation NVARCHAR(255),
    Date DATE,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (Plate) REFERENCES Cars(Plate)
);

-- Monthly reports
CREATE TABLE MonthlyReportsForTotalAccidents (
    ReportID NVARCHAR(50) PRIMARY KEY,
    Month NVARCHAR(20),
    TotalAccidents INT,
    GeneratedBy NVARCHAR(50),
    GeneratedDate DATE,
    FOREIGN KEY (GeneratedBy) REFERENCES SystemUser(Name)
);
