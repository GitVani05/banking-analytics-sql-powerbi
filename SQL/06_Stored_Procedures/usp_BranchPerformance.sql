USE BankingDW;
GO

CREATE OR ALTER PROCEDURE dbo.usp_BranchPerformance
AS
BEGIN

    SET NOCOUNT ON;

    SELECT

        BranchName,

        TotalTransactions,

        ActiveCustomers,

        TotalTransactionAmount,

        TotalRevenue,

        AvgProcessingTime,

        SuccessfulTransactions,

        FailedTransactions,

        CAST(

            SuccessfulTransactions * 100.0 /

            NULLIF(
                SuccessfulTransactions +
                FailedTransactions,
                0
            )

        AS DECIMAL(5,2))

        AS SuccessRate

    FROM dbo.vw_BranchPerformance

    ORDER BY TotalRevenue DESC;

END
GO

EXEC dbo.usp_BranchPerformance;