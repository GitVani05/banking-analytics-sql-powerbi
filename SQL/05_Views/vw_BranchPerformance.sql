USE BankingDW;
GO

CREATE OR ALTER VIEW dbo.vw_BranchPerformance
AS

SELECT

    b.BranchID,
    b.BranchName,
    b.City,
    b.State,

    COUNT(ft.TransactionID) AS TotalTransactions,

    COUNT(DISTINCT ft.CustomerID) AS ActiveCustomers,

    SUM(ft.Amount) AS TotalTransactionAmount,

    SUM(ft.RevenueAmount) AS TotalRevenue,

    AVG(CAST(ft.ProcessingTimeSeconds AS DECIMAL(10,2)))
        AS AvgProcessingTime,

    SUM(CASE
            WHEN ft.TransactionStatus='Completed'
            THEN 1
            ELSE 0
        END) AS SuccessfulTransactions,

    SUM(CASE
            WHEN ft.TransactionStatus<>'Completed'
            THEN 1
            ELSE 0
        END) AS FailedTransactions

FROM dbo.DimBranch b

LEFT JOIN dbo.FactTransactions ft
    ON b.BranchID = ft.BranchID

GROUP BY

    b.BranchID,
    b.BranchName,
    b.City,
    b.State;
GO

SELECT TOP 10 *
FROM dbo.vw_BranchPerformance;

SELECT COUNT(*)
FROM dbo.vw_BranchPerformance;

SELECT TOP (10)

    BranchName,

    TotalRevenue,

    TotalTransactions,

    ActiveCustomers

FROM dbo.vw_BranchPerformance

ORDER BY TotalRevenue DESC;

SELECT

    BranchName,

    AvgProcessingTime

FROM dbo.vw_BranchPerformance

ORDER BY AvgProcessingTime;

SELECT

    BranchName,

    SuccessfulTransactions,

    FailedTransactions,

    CAST(
        SuccessfulTransactions * 100.0 /
        NULLIF(
            SuccessfulTransactions + FailedTransactions,
            0
        )
        AS DECIMAL(5,2)
    ) AS SuccessRate

FROM dbo.vw_BranchPerformance

ORDER BY SuccessRate DESC;