USE BankingDW;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CustomerAnalytics
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CustomerID,
        CustomerName,
        BranchName,
        NumberOfAccounts,
        TotalTransactions,
        TotalTransactionValue,
        TotalRevenue,
        AverageTransactionAmount,
        LastTransactionDate
    FROM dbo.vw_CustomerAnalytics
    ORDER BY TotalRevenue DESC;
END;
GO

EXEC dbo.usp_CustomerAnalytics;