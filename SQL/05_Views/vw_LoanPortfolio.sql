USE BankingDW;
GO

CREATE OR ALTER VIEW dbo.vw_LoanPortfolio
AS

SELECT

    fl.LoanID,

    c.CustomerID,

    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,

    b.BranchID,
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

    fl.IsNonPerforming

FROM dbo.FactLoans fl

INNER JOIN dbo.DimCustomer c
    ON fl.CustomerID = c.CustomerID

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

SELECT COUNT(*) AS LoanRows
FROM dbo.vw_LoanPortfolio;

SELECT TOP (10) *
FROM dbo.vw_LoanPortfolio;

SELECT

    COUNT(*) AS TotalLoans,

    SUM(LoanAmount) AS TotalLoanAmount,

    SUM(OutstandingBalance) AS TotalOutstandingBalance,

    AVG(InterestRate) AS AverageInterestRate,

    AVG(LoanAmount) AS AverageLoanSize

FROM dbo.vw_LoanPortfolio;

SELECT

    LoanTypeName,

    COUNT(*) AS NumberOfLoans,

    SUM(OutstandingBalance) AS OutstandingBalance

FROM dbo.vw_LoanPortfolio

GROUP BY LoanTypeName

ORDER BY OutstandingBalance DESC;

SELECT

    BranchName,

    SUM(OutstandingBalance) AS Portfolio

FROM dbo.vw_LoanPortfolio

GROUP BY BranchName

ORDER BY Portfolio DESC;

SELECT

    CreditScoreTier,

    AVG(InterestRate) AS AvgInterestRate

FROM dbo.vw_LoanPortfolio

GROUP BY CreditScoreTier

ORDER BY AvgInterestRate;