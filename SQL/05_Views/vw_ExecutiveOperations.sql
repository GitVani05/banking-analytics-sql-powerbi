USE BankingDW;
GO

CREATE OR ALTER VIEW dbo.vw_ExecutiveOperations
AS

SELECT

    ft.TransactionID,

    d.FullDate AS TransactionDate,

    ft.DateKey,

    c.CustomerID,

    CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,

    a.AccountNumber,

    a.AccountType,

    b.BranchID,

    b.BranchName,

    b.City,

    b.State,

    ft.TransactionType,

    ft.Amount,

    ft.FeeAmount,

    ft.RevenueAmount,

    ft.ProcessingTimeSeconds,

    ft.Channel,

    ft.TransactionStatus

FROM dbo.FactTransactions ft

INNER JOIN dbo.DimCustomer c
ON ft.CustomerID = c.CustomerID

INNER JOIN dbo.DimAccount a
ON ft.AccountID = a.AccountID

INNER JOIN dbo.DimBranch b
ON ft.BranchID = b.BranchID

INNER JOIN dbo.DimDate d
ON ft.DateKey = d.DateKey;
GO

SELECT TOP 10 *
FROM dbo.vw_ExecutiveOperations;

SELECT COUNT(*)
FROM dbo.vw_ExecutiveOperations;

SELECT

    COUNT(*) AS TotalTransactions,

    SUM(Amount) AS TotalTransactionValue,

    SUM(RevenueAmount) AS TotalRevenue,

    AVG(ProcessingTimeSeconds) AS AvgProcessingTime

FROM dbo.vw_ExecutiveOperations;

SELECT

    BranchName,

    SUM(RevenueAmount) AS Revenue

FROM dbo.vw_ExecutiveOperations

GROUP BY BranchName

ORDER BY Revenue DESC;

SELECT

    YEAR(TransactionDate) AS Year,

    MONTH(TransactionDate) AS Month,

    COUNT(*) AS Transactions,

    SUM(RevenueAmount) AS Revenue

FROM dbo.vw_ExecutiveOperations

GROUP BY

    YEAR(TransactionDate),

    MONTH(TransactionDate)

ORDER BY

    Year,

    Month;