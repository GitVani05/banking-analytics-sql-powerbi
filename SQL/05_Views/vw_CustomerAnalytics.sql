USE BankingDW;
GO

CREATE OR ALTER VIEW dbo.vw_CustomerAnalytics
AS

WITH CustomerHomeBranch AS
(
    SELECT
        CustomerID,
        BranchID,
        ROW_NUMBER() OVER
        (
            PARTITION BY CustomerID
            ORDER BY AccountID
        ) AS rn
    FROM dbo.DimAccount
)

SELECT

    c.CustomerID,

    CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

    c.Gender,

    c.City,

    c.State,

    b.BranchName,

    COUNT(DISTINCT a.AccountID) AS NumberOfAccounts,

    COUNT(ft.TransactionID) AS TotalTransactions,

    ISNULL(SUM(ft.Amount),0) AS TotalTransactionValue,

    ISNULL(SUM(ft.RevenueAmount),0) AS TotalRevenue,

    ISNULL(AVG(CAST(ft.Amount AS DECIMAL(18,2))),0)
        AS AverageTransactionAmount,

    MAX(d.FullDate) AS LastTransactionDate

FROM dbo.DimCustomer c

LEFT JOIN dbo.DimAccount a
    ON c.CustomerID = a.CustomerID

LEFT JOIN CustomerHomeBranch hb
    ON c.CustomerID = hb.CustomerID
    AND hb.rn = 1

LEFT JOIN dbo.DimBranch b
    ON hb.BranchID = b.BranchID

LEFT JOIN dbo.FactTransactions ft
    ON a.AccountID = ft.AccountID

LEFT JOIN dbo.DimDate d
    ON ft.DateKey = d.DateKey

GROUP BY

    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Gender,
    c.City,
    c.State,
    b.BranchName;
GO

SELECT TOP 10 *
FROM dbo.vw_CustomerAnalytics;

SELECT COUNT(*) AS CustomerRows
FROM dbo.vw_CustomerAnalytics;

SELECT TOP (10)

    CustomerName,

    BranchName,

    TotalRevenue,

    TotalTransactions

FROM dbo.vw_CustomerAnalytics

ORDER BY TotalRevenue DESC;

SELECT TOP (10)

    CustomerName,

    TotalTransactionValue

FROM dbo.vw_CustomerAnalytics

ORDER BY TotalTransactionValue DESC;

SELECT

    COUNT(*) AS Customers,

    AVG(TotalTransactions) AS AvgTransactionsPerCustomer,

    AVG(NumberOfAccounts) AS AvgAccountsPerCustomer

FROM dbo.vw_CustomerAnalytics;