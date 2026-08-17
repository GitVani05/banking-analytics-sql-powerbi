USE BankingDW;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CreditRiskSummary
AS
BEGIN
    SET NOCOUNT ON;

    -- Executive Risk KPIs
    SELECT
        COUNT(*) AS TotalLoans,
        SUM(CAST(IsNonPerforming AS INT)) AS NPLLoans,
        CAST(
            SUM(CAST(IsNonPerforming AS INT)) * 100.0 / COUNT(*)
            AS DECIMAL(5,2)
        ) AS NPLRatio,
        AVG(InterestRate) AS AverageInterestRate,
        SUM(OutstandingBalance) AS TotalExposure
    FROM dbo.vw_CreditRisk;

    -- Exposure by Credit Tier
    SELECT
        CreditScoreTier,
        COUNT(*) AS Loans,
        SUM(OutstandingBalance) AS Exposure
    FROM dbo.vw_CreditRisk
    GROUP BY CreditScoreTier
    ORDER BY Exposure DESC;

    -- Delinquency Analysis
    SELECT
        DelinquencyBucket,
        COUNT(*) AS Loans,
        SUM(OutstandingBalance) AS Exposure
    FROM dbo.vw_CreditRisk
    GROUP BY DelinquencyBucket
    ORDER BY Exposure DESC;

    -- High-Risk Branches
    SELECT
        BranchName,
        SUM(CAST(IsNonPerforming AS INT)) AS NPLLoans,
        SUM(OutstandingBalance) AS Exposure
    FROM dbo.vw_CreditRisk
    GROUP BY BranchName
    ORDER BY NPLLoans DESC, Exposure DESC;
END;
GO

EXEC dbo.usp_CreditRiskSummary;