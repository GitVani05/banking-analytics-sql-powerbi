USE BankingDW;
GO

CREATE TABLE dbo.StgFactLoans
(
    CustomerID INT,
    BranchID INT,
    LoanTypeID INT,
    CreditScoreTierID INT,
    OriginationDateKey INT,
    MaturityDateKey INT,
    LoanAmount DECIMAL(18,2),
    OutstandingBalance DECIMAL(18,2),
    InterestRate DECIMAL(5,2),
    TermMonths INT,
    MonthlyPayment DECIMAL(18,2),
    DaysPastDue INT,
    LoanStatus VARCHAR(30),
    IsNonPerforming BIT
);
GO

SELECT COUNT(*)
FROM dbo.StgFactLoans;

BULK INSERT dbo.StgFactLoans
FROM 'C:\WordDoc\BankingBIProject\data\raw\FactLoans.csv'
WITH
(
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDQUOTE='"',
    TABLOCK
);
GO

SELECT COUNT(*) AS LoanCount
FROM dbo.StgFactLoans;

SELECT COUNT(*) AS InvalidCustomers
FROM dbo.StgFactLoans l
LEFT JOIN dbo.DimCustomer c
    ON l.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

SELECT COUNT(*) AS InvalidLoanTypes
FROM dbo.StgFactLoans l
LEFT JOIN dbo.DimLoanType t
    ON l.LoanTypeID = t.LoanTypeID
WHERE t.LoanTypeID IS NULL;

SELECT COUNT(*) AS InvalidCreditTiers
FROM dbo.StgFactLoans l
LEFT JOIN dbo.DimCreditScoreTier c
    ON l.CreditScoreTierID = c.CreditScoreTierID
WHERE c.CreditScoreTierID IS NULL;

SELECT
    SUM(CASE WHEN d1.DateKey IS NULL THEN 1 ELSE 0 END) AS InvalidOriginationDates,
    SUM(CASE WHEN d2.DateKey IS NULL THEN 1 ELSE 0 END) AS InvalidMaturityDates
FROM dbo.StgFactLoans l
LEFT JOIN dbo.DimDate d1
    ON l.OriginationDateKey = d1.DateKey
LEFT JOIN dbo.DimDate d2
    ON l.MaturityDateKey = d2.DateKey;

SELECT
    MAX(DateKey) AS MaxDateKey,
    MAX(FullDate) AS MaxDate
FROM dbo.DimDate;

