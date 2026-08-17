USE BankingDW;
GO

CREATE OR ALTER VIEW dbo.vw_CreditRisk
AS

SELECT

    fl.LoanID,

    b.BranchName,

    b.City,

    b.State,

    lt.LoanTypeName,

    cs.TierName AS CreditScoreTier,

    od.FullDate AS OriginationDate,

    md.FullDate AS MaturityDate,

    fl.LoanAmount,

    fl.OutstandingBalance,

    fl.InterestRate,

    fl.TermMonths,

    fl.MonthlyPayment,

    fl.DaysPastDue,

    fl.LoanStatus,

    fl.IsNonPerforming,

    CASE
        WHEN fl.DaysPastDue >= 90 THEN '90+ Days'
        WHEN fl.DaysPastDue >= 60 THEN '60 Days'
        WHEN fl.DaysPastDue >= 30 THEN '30 Days'
        ELSE 'Current'
    END AS DelinquencyBucket

FROM dbo.FactLoans fl

INNER JOIN dbo.DimBranch b
ON fl.BranchID = b.BranchID

INNER JOIN dbo.DimLoanType lt
ON fl.LoanTypeID = lt.LoanTypeID

INNER JOIN dbo.DimCreditScoreTier cs
ON fl.CreditScoreTierID = cs.CreditScoreTierID

INNER JOIN dbo.DimDate od
ON fl.OriginationDateKey = od.DateKey

INNER JOIN dbo.DimDate md
ON fl.MaturityDateKey = md.DateKey;
GO

SELECT COUNT(*)
FROM dbo.vw_CreditRisk;

SELECT

    COUNT(*) AS TotalLoans,

    SUM(CAST(IsNonPerforming AS INT)) AS NPLLoans,

    CAST(
        SUM(CAST(IsNonPerforming AS INT)) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS NPLRatio

FROM dbo.vw_CreditRisk;

SELECT

DelinquencyBucket,

COUNT(*) AS Loans,

SUM(OutstandingBalance) AS Exposure

FROM dbo.vw_CreditRisk

GROUP BY DelinquencyBucket

ORDER BY Exposure DESC;

SELECT

CreditScoreTier,

SUM(OutstandingBalance) AS Exposure

FROM dbo.vw_CreditRisk

GROUP BY CreditScoreTier

ORDER BY Exposure DESC;

SELECT

LoanTypeName,

SUM(OutstandingBalance) AS Exposure

FROM dbo.vw_CreditRisk

GROUP BY LoanTypeName

ORDER BY Exposure DESC;

SELECT

    BranchName,

    SUM(CAST(IsNonPerforming AS INT)) AS NPLLoans,

    SUM(OutstandingBalance) AS Exposure

FROM dbo.vw_CreditRisk

GROUP BY BranchName

ORDER BY NPLLoans DESC;