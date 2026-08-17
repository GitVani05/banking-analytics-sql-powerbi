USE BankingDW;
GO

SET IDENTITY_INSERT dbo.DimBranch ON;
GO

BULK INSERT dbo.DimBranch
FROM 'C:\WordDoc\BankingBIProject\data\raw\DimBranch.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    KEEPIDENTITY,
    TABLOCK
);
GO

SET IDENTITY_INSERT dbo.DimBranch OFF;
GO

SELECT COUNT(*) AS BranchCount
FROM dbo.DimBranch;

SELECT TOP 10
    BranchID,
    BranchName,
    City,
    State,
    Region
FROM dbo.DimBranch
ORDER BY BranchID;

SELECT COUNT(*) AS BranchCount
FROM dbo.DimBranch;

SELECT TOP 10 *
FROM dbo.DimBranch
ORDER BY BranchID;

SET IDENTITY_INSERT dbo.DimCustomer ON;
GO

BULK INSERT dbo.DimCustomer
FROM 'C:\WordDoc\BankingBIProject\data\raw\DimCustomer.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    KEEPIDENTITY,
    TABLOCK
);
GO

SET IDENTITY_INSERT dbo.DimCustomer OFF;
GO

SELECT COUNT(*) AS CustomerCount
FROM dbo.DimCustomer;

SELECT TOP 5
    CustomerID,
    FirstName,
    LastName,
    AnnualIncome,
    City,
    State,
    CustomerSegment
FROM dbo.DimCustomer
ORDER BY CustomerID;

USE BankingDW;
GO

SET IDENTITY_INSERT dbo.DimCustomer OFF;
GO

SELECT COUNT(*) AS CustomerCount
FROM dbo.DimCustomer;

SELECT COUNT(*) AS AccountCount
FROM dbo.DimAccount;

USE BankingDW;
GO

CREATE TABLE dbo.StgDimAccount (
    AccountID INT,
    CustomerID INT,
    AccountNumber VARCHAR(20),
    AccountType VARCHAR(30),
    BranchID INT,
    OpenDate DATE,
    CurrentBalance DECIMAL(18,2),
    Status VARCHAR(20)
);
GO

BULK INSERT dbo.StgDimAccount
FROM 'C:\WordDoc\BankingBIProject\data\raw\DimAccount.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);
GO

SELECT COUNT(*) AS StagingAccountCount
FROM dbo.StgDimAccount;

SELECT TOP 5 *
FROM dbo.StgDimAccount
ORDER BY AccountID;

SET IDENTITY_INSERT dbo.DimAccount ON;
GO

INSERT INTO dbo.DimAccount
(
    AccountID,
    CustomerID,
    AccountNumber,
    AccountType,
    OpenDate,
    CurrentBalance,
    Status,
    BranchID
)
SELECT
    AccountID,
    CustomerID,
    AccountNumber,
    AccountType,
    OpenDate,
    CurrentBalance,
    Status,
    BranchID
FROM dbo.StgDimAccount;
GO

SET IDENTITY_INSERT dbo.DimAccount OFF;
GO

SELECT TOP 10 *
FROM dbo.DimAccount
ORDER BY AccountID;

SELECT COUNT(*) AS OrphanedAccounts
FROM dbo.DimAccount a
LEFT JOIN dbo.DimCustomer c
    ON a.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

SELECT COUNT(*) AS OrphanedBranchAccounts
FROM dbo.DimAccount a
LEFT JOIN dbo.DimBranch b
    ON a.BranchID = b.BranchID
WHERE b.BranchID IS NULL;

DROP TABLE dbo.StgDimAccount;
GO

SELECT
    (SELECT COUNT(*) FROM dbo.DimBranch) AS Branches,
    (SELECT COUNT(*) FROM dbo.DimCustomer) AS Customers,
    (SELECT COUNT(*) FROM dbo.DimAccount) AS Accounts;