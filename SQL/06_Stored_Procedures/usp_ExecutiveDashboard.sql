USE BankingDW;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ExecutiveDashboard
AS
BEGIN

    SET NOCOUNT ON;

    SELECT

        COUNT(*) AS TotalTransactions,

        COUNT(DISTINCT CustomerID) AS ActiveCustomers,

        COUNT(DISTINCT BranchID) AS ActiveBranches,

        SUM(Amount) AS TotalTransactionValue,

        SUM(RevenueAmount) AS TotalRevenue,

        AVG(CAST(ProcessingTimeSeconds AS DECIMAL(10,2)))
            AS AvgProcessingTime

    FROM dbo.vw_ExecutiveOperations;

END
GO

EXEC dbo.usp_ExecutiveDashboard;