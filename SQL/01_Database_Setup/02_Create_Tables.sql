USE BankingDW;
GO

-- ==========================================
-- Table: DimBranch
-- Description: Stores branch information
-- ==========================================

CREATE TABLE DimBranch (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    OpeningDate DATE,
    ManagerName VARCHAR(100),
    Status VARCHAR(20) DEFAULT 'Active'
);
GO

USE BankingDW;
GO

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- ==========================================
-- Table: DimCustomer
-- Description: Stores customer information
-- ==========================================

CREATE TABLE DimCustomer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Gender VARCHAR(20),
    Occupation VARCHAR(100),
    AnnualIncome DECIMAL(15,2),
    City VARCHAR(50),
    State VARCHAR(50),
    CustomerSegment VARCHAR(50),
    JoinDate DATE,
    RiskCategory VARCHAR(30),
    Status VARCHAR(20) DEFAULT 'Active'
);
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

EXEC sp_help 'dbo.DimCustomer';

-- ==========================================
-- Table: DimAccount
-- Description: Stores bank account information
-- ==========================================

CREATE TABLE DimAccount (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountNumber VARCHAR(20) NOT NULL,
    AccountType VARCHAR(30) NOT NULL,
    OpenDate DATE NOT NULL,
    CurrentBalance DECIMAL(18,2) DEFAULT 0,
    Status VARCHAR(20) DEFAULT 'Active',

    CONSTRAINT FK_DimAccount_DimCustomer
        FOREIGN KEY (CustomerID)
        REFERENCES DimCustomer(CustomerID)
);
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

EXEC sp_help 'dbo.DimAccount';

-- ==========================================
-- Table: DimLoanType
-- Description: Defines the bank's loan products
-- ==========================================
USE BankingDW;
GO


CREATE TABLE DimLoanType (
    LoanTypeID INT IDENTITY(1,1) PRIMARY KEY,
    LoanTypeName VARCHAR(50) NOT NULL,
    LoanCategory VARCHAR(50) NOT NULL,
    Description VARCHAR(255)
);
GO

-- ==========================================
-- Table: DimCreditScoreTier
-- Description: Defines credit score risk tiers
-- ==========================================

CREATE TABLE DimCreditScoreTier (
    CreditScoreTierID INT IDENTITY(1,1) PRIMARY KEY,
    TierName VARCHAR(30) NOT NULL,
    MinScore INT NOT NULL,
    MaxScore INT NOT NULL,
    RiskLevel VARCHAR(30) NOT NULL
);
GO

-- ==========================================
-- Table: DimDate
-- Description: Calendar dimension for reporting
-- ==========================================

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    DayNumber INT NOT NULL,
    DayName VARCHAR(20) NOT NULL,
    WeekNumber INT NOT NULL,
    MonthNumber INT NOT NULL,
    MonthName VARCHAR(20) NOT NULL,
    QuarterNumber INT NOT NULL,
    QuarterName VARCHAR(10) NOT NULL,
    YearNumber INT NOT NULL,
    MonthYear VARCHAR(20) NOT NULL
);
GO
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

EXEC sp_help 'dbo.DimLoanType';
EXEC sp_help 'dbo.DimCreditScoreTier';
EXEC sp_help 'dbo.DimDate';

-- ==========================================
-- Populate: DimLoanType
-- ==========================================

INSERT INTO DimLoanType
    (LoanTypeName, LoanCategory, Description)
VALUES
    ('30-Year Mortgage', 'Mortgage', '30-year residential mortgage'),
    ('15-Year Mortgage', 'Mortgage', '15-year residential mortgage'),
    ('Auto Loan', 'Auto', 'Vehicle financing'),
    ('Commercial Loan', 'Commercial', 'Business and commercial financing'),
    ('Personal Loan', 'Personal', 'Unsecured personal financing'),
    ('Student Loan', 'Student', 'Education financing');
GO
SELECT * FROM DimLoanType;
-- ==========================================
-- Populate: DimCreditScoreTier
-- ==========================================

INSERT INTO DimCreditScoreTier
    (TierName, MinScore, MaxScore, RiskLevel)
VALUES
    ('Excellent', 800, 850, 'Very Low'),
    ('Very Good', 740, 799, 'Low'),
    ('Good', 670, 739, 'Moderate'),
    ('Fair', 580, 669, 'High'),
    ('Poor', 300, 579, 'Very High');
GO
SELECT *
FROM DimCreditScoreTier
ORDER BY MinScore DESC;

-- ==========================================
-- Populate: DimDate
-- Date range: 2020-01-01 through 2030-12-31
-- ==========================================

DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate   DATE = '2030-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate
    (
        DateKey,
        FullDate,
        DayNumber,
        DayName,
        WeekNumber,
        MonthNumber,
        MonthName,
        QuarterNumber,
        QuarterName,
        YearNumber,
        MonthYear
    )
    VALUES
    (
        CONVERT(INT, CONVERT(CHAR(8), @StartDate, 112)),
        @StartDate,
        DAY(@StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DATEPART(WEEK, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(QUARTER, @StartDate),
        'Q' + CAST(DATEPART(QUARTER, @StartDate) AS VARCHAR(1)),
        YEAR(@StartDate),
        DATENAME(MONTH, @StartDate) + ' ' + CAST(YEAR(@StartDate) AS VARCHAR(4))
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO

SELECT
    COUNT(*) AS DateCount,
    MIN(FullDate) AS FirstDate,
    MAX(FullDate) AS LastDate
FROM DimDate;

SELECT TOP 10 *
FROM DimDate
ORDER BY FullDate;

-- ==========================================
-- Table: FactTransactions
-- Description: Stores individual banking transactions
-- ==========================================

CREATE TABLE FactTransactions (
    TransactionID BIGINT IDENTITY(1,1) PRIMARY KEY,

    CustomerID INT NOT NULL,
    AccountID INT NOT NULL,
    BranchID INT NOT NULL,
    DateKey INT NOT NULL,

    TransactionType VARCHAR(30) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    ProcessingTimeSeconds INT,
    FeeAmount DECIMAL(18,2) DEFAULT 0,
    RevenueAmount DECIMAL(18,2) DEFAULT 0,

    TransactionStatus VARCHAR(20) NOT NULL,
    Channel VARCHAR(30) NOT NULL,

    CONSTRAINT FK_FactTransactions_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES DimCustomer(CustomerID),

    CONSTRAINT FK_FactTransactions_Account
        FOREIGN KEY (AccountID)
        REFERENCES DimAccount(AccountID),

    CONSTRAINT FK_FactTransactions_Branch
        FOREIGN KEY (BranchID)
        REFERENCES DimBranch(BranchID),

    CONSTRAINT FK_FactTransactions_Date
        FOREIGN KEY (DateKey)
        REFERENCES DimDate(DateKey)
);
GO

EXEC sp_help 'dbo.FactTransactions';

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

USE BankingDW;
GO

ALTER TABLE DimAccount
ADD BranchID INT NULL;
GO

ALTER TABLE DimAccount
ADD CONSTRAINT FK_DimAccount_DimBranch
    FOREIGN KEY (BranchID)
    REFERENCES DimBranch(BranchID);
GO

EXEC sp_help 'dbo.DimAccount';

USE BankingDW;
GO

SET IDENTITY_INSERT dbo.DimBranch ON;

SELECT 
    SERVERPROPERTY('ProductVersion') AS SQLServerVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('Edition') AS Edition;

SELECT @@SERVERNAME AS ServerName;