USE BankingDW;
GO

CREATE OR ALTER PROCEDURE dbo.usp_LoanPortfolioSummary
AS
BEGIN
    SET NOCOUNT ON;

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
        SUM(OutstandingBalance) AS PortfolioExposure
    FROM dbo.vw_LoanPortfolio
    GROUP BY BranchName
    ORDER BY PortfolioExposure DESC;
END;
GO

EXEC dbo.usp_LoanPortfolioSummary;