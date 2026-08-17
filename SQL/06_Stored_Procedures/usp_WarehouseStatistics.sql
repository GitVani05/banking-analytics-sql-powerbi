USE BankingDW;
GO

CREATE OR ALTER PROCEDURE dbo.usp_WarehouseStatistics
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        (SELECT COUNT(*) FROM dbo.DimCustomer) AS Customers,
        (SELECT COUNT(*) FROM dbo.DimBranch) AS Branches,
        (SELECT COUNT(*) FROM dbo.DimAccount) AS Accounts,
        (SELECT COUNT(*) FROM dbo.DimLoanType) AS LoanTypes,
        (SELECT COUNT(*) FROM dbo.DimCreditScoreTier) AS CreditScoreTiers,
        (SELECT COUNT(*) FROM dbo.DimDate) AS Dates,
        (SELECT COUNT(*) FROM dbo.FactTransactions) AS Transactions,
        (SELECT COUNT(*) FROM dbo.FactLoans) AS Loans;
END;
GO

EXEC dbo.usp_WarehouseStatistics;


SELECT name, type_desc
FROM sys.objects
WHERE name LIKE 'vw_%'
   OR name LIKE 'usp_%'
ORDER BY type_desc, name;