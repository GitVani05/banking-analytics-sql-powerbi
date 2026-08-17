USE BankingDW;
GO

CREATE TABLE dbo.StgFactTransactions (
    CustomerID INT,
    AccountID INT,
    BranchID INT,
    DateKey INT,
    TransactionType VARCHAR(30),
    Amount DECIMAL(18,2),
    ProcessingTimeSeconds INT,
    FeeAmount DECIMAL(18,2),
    RevenueAmount DECIMAL(18,2),
    TransactionStatus VARCHAR(20),
    Channel VARCHAR(30)
);
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'StgFactTransactions';

BULK INSERT dbo.StgFactTransactions
FROM 'C:\WordDoc\BankingBIProject\data\raw\FactTransactions.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);
GO

SELECT COUNT(*) AS StagingTransactionCount
FROM dbo.StgFactTransactions;

SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomers,
    SUM(CASE WHEN AccountID IS NULL THEN 1 ELSE 0 END) AS NullAccounts,
    SUM(CASE WHEN BranchID IS NULL THEN 1 ELSE 0 END) AS NullBranches,
    SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS NullDates,
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS NullAmounts
FROM dbo.StgFactTransactions;

SELECT COUNT(*) AS NegativeTransactions
FROM dbo.StgFactTransactions
WHERE Amount < 0;

SELECT COUNT(*) AS InvalidCustomers
FROM dbo.StgFactTransactions t
LEFT JOIN dbo.DimCustomer c
    ON t.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

SELECT COUNT(*) AS InvalidAccounts
FROM dbo.StgFactTransactions t
LEFT JOIN dbo.DimAccount a
    ON t.AccountID = a.AccountID
WHERE a.AccountID IS NULL;

SELECT COUNT(*) AS InvalidBranches
FROM dbo.StgFactTransactions t
LEFT JOIN dbo.DimBranch b
    ON t.BranchID = b.BranchID
WHERE b.BranchID IS NULL;

SELECT COUNT(*) AS InvalidDates
FROM dbo.StgFactTransactions t
LEFT JOIN dbo.DimDate d
    ON t.DateKey = d.DateKey
WHERE d.DateKey IS NULL;

SELECT TOP 5 *
FROM dbo.DimDate;

SELECT
    COUNT(*) AS DateCount,
    MIN(FullDate) AS FirstDate,
    MAX(FullDate) AS LastDate
FROM dbo.DimDate;

INSERT INTO dbo.FactTransactions
(
    CustomerID,
    AccountID,
    BranchID,
    DateKey,
    TransactionType,
    Amount,
    ProcessingTimeSeconds,
    FeeAmount,
    RevenueAmount,
    TransactionStatus,
    Channel
)
SELECT
    CustomerID,
    AccountID,
    BranchID,
    DateKey,
    TransactionType,
    Amount,
    ProcessingTimeSeconds,
    FeeAmount,
    RevenueAmount,
    TransactionStatus,
    Channel
FROM dbo.StgFactTransactions;
GO

SELECT COUNT(*) AS TransactionCount
FROM dbo.FactTransactions;

SELECT
    COUNT(*) AS TransactionCount,
    SUM(Amount) AS TotalTransactionValue,
    SUM(RevenueAmount) AS TotalRevenue,
    AVG(CAST(ProcessingTimeSeconds AS DECIMAL(18,2))) AS AvgProcessingTime
FROM dbo.FactTransactions;

CREATE INDEX IX_FactTransactions_CustomerID
ON dbo.FactTransactions(CustomerID);
GO

CREATE INDEX IX_FactTransactions_AccountID
ON dbo.FactTransactions(AccountID);
GO

CREATE INDEX IX_FactTransactions_BranchID
ON dbo.FactTransactions(BranchID);
GO

CREATE INDEX IX_FactTransactions_DateKey
ON dbo.FactTransactions(DateKey);
GO

SELECT
    b.BranchName,
    b.City,
    b.State,
    COUNT(t.TransactionID) AS TransactionCount,
    SUM(t.Amount) AS TransactionValue,
    SUM(t.RevenueAmount) AS Revenue
FROM dbo.FactTransactions t
INNER JOIN dbo.DimBranch b
    ON t.BranchID = b.BranchID
GROUP BY
    b.BranchName,
    b.City,
    b.State
ORDER BY Revenue DESC;

DROP TABLE dbo.StgFactTransactions;
GO

EXEC sp_help 'dbo.FactLoans';