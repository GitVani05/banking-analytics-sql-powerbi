USE BankingDW;
GO

/* ============================================================
   BankingDW - Data Quality Validation
   Purpose:
   Validate row counts, referential integrity, transaction
   quality, loan quality, and date-dimension coverage.
   ============================================================ */


/* ============================================================
   1. CORE TABLE ROW COUNTS
   ============================================================ */

SELECT 'DimBranch' AS TableName, COUNT(*) AS RowCount
FROM dbo.DimBranch
UNION ALL
SELECT 'DimCustomer', COUNT(*)
FROM dbo.DimCustomer
UNION ALL
SELECT 'DimAccount', COUNT(*)
FROM dbo.DimAccount
UNION ALL
SELECT 'DimLoanType', COUNT(*)
FROM dbo.DimLoanType
UNION ALL
SELECT 'DimCreditScoreTier', COUNT(*)
FROM dbo.DimCreditScoreTier
UNION ALL
SELECT 'DimDate', COUNT(*)
FROM dbo.DimDate
UNION ALL
SELECT 'FactTransactions', COUNT(*)
FROM dbo.FactTransactions
UNION ALL
SELECT 'FactLoans', COUNT(*)
FROM dbo.FactLoans;
GO


/* ============================================================
   2. DIMDATE COVERAGE
   Expected final range:
   2020-01-01 through 2065-12-31
   ============================================================ */

SELECT
    MIN(FullDate) AS FirstDate,
    MAX(FullDate) AS LastDate,
    COUNT(*) AS TotalDates
FROM dbo.DimDate;
GO


/* ============================================================
   3. TRANSACTION NULL / INVALID VALUE CHECKS
   ============================================================ */

SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END)
        AS NullCustomerIDs,
    SUM(CASE WHEN AccountID IS NULL THEN 1 ELSE 0 END)
        AS NullAccountIDs,
    SUM(CASE WHEN BranchID IS NULL THEN 1 ELSE 0 END)
        AS NullBranchIDs,
    SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END)
        AS NullDateKeys,
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END)
        AS NullAmounts,
    SUM(CASE WHEN Amount < 0 THEN 1 ELSE 0 END)
        AS NegativeAmounts
FROM dbo.FactTransactions;
GO


/* ============================================================
   4. TRANSACTION REFERENTIAL-INTEGRITY CHECKS
   All results should be 0.
   ============================================================ */

SELECT COUNT(*) AS InvalidCustomerIDs
FROM dbo.FactTransactions ft
LEFT JOIN dbo.DimCustomer dc
    ON ft.CustomerID = dc.CustomerID
WHERE dc.CustomerID IS NULL;
GO

SELECT COUNT(*) AS InvalidAccountIDs
FROM dbo.FactTransactions ft
LEFT JOIN dbo.DimAccount da
    ON ft.AccountID = da.AccountID
WHERE da.AccountID IS NULL;
GO

SELECT COUNT(*) AS InvalidBranchIDs
FROM dbo.FactTransactions ft
LEFT JOIN dbo.DimBranch db
    ON ft.BranchID = db.BranchID
WHERE db.BranchID IS NULL;
GO

SELECT COUNT(*) AS InvalidTransactionDateKeys
FROM dbo.FactTransactions ft
LEFT JOIN dbo.DimDate dd
    ON ft.DateKey = dd.DateKey
WHERE dd.DateKey IS NULL;
GO


/* ============================================================
   5. TRANSACTIONS PER CUSTOMER
   Project benchmark: approximately 20
   ============================================================ */

SELECT
    COUNT(DISTINCT CustomerID) AS Customers,
    COUNT(*) * 1.0 /
        NULLIF(COUNT(DISTINCT CustomerID), 0)
        AS AvgTransactionsPerCustomer
FROM dbo.FactTransactions;
GO


/* ============================================================
   6. ACCOUNT OWNERSHIP CHECK
   Transaction CustomerID should match the customer who owns
   the corresponding account.
   ============================================================ */

SELECT COUNT(*) AS CustomerAccountMismatches
FROM dbo.FactTransactions ft
INNER JOIN dbo.DimAccount da
    ON ft.AccountID = da.AccountID
WHERE ft.CustomerID <> da.CustomerID;
GO


/* ============================================================
   7. LOAN NULL CHECKS
   ============================================================ */

SELECT
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END)
        AS NullCustomerIDs,
    SUM(CASE WHEN BranchID IS NULL THEN 1 ELSE 0 END)
        AS NullBranchIDs,
    SUM(CASE WHEN LoanTypeID IS NULL THEN 1 ELSE 0 END)
        AS NullLoanTypeIDs,
    SUM(CASE WHEN CreditScoreTierID IS NULL THEN 1 ELSE 0 END)
        AS NullCreditScoreTierIDs,
    SUM(CASE WHEN OriginationDateKey IS NULL THEN 1 ELSE 0 END)
        AS NullOriginationDateKeys,
    SUM(CASE WHEN MaturityDateKey IS NULL THEN 1 ELSE 0 END)
        AS NullMaturityDateKeys
FROM dbo.FactLoans;
GO


/* ============================================================
   8. LOAN BALANCE VALIDATION
   Outstanding balance should not exceed original loan amount.
   ============================================================ */

SELECT COUNT(*) AS InvalidOutstandingBalances
FROM dbo.FactLoans
WHERE OutstandingBalance > LoanAmount;
GO


/* ============================================================
   9. LOAN STATUS VALIDATION
   ============================================================ */

SELECT
    LoanStatus,
    COUNT(*) AS LoanCount
FROM dbo.FactLoans
GROUP BY LoanStatus
ORDER BY LoanStatus;
GO


/* ============================================================
   10. NON-PERFORMING FLAG VALIDATION
   IsNonPerforming should contain only 0 or 1.
   ============================================================ */

SELECT
    IsNonPerforming,
    COUNT(*) AS LoanCount
FROM dbo.FactLoans
GROUP BY IsNonPerforming
ORDER BY IsNonPerforming;
GO


/* ============================================================
   11. LOAN DATE REFERENTIAL-INTEGRITY CHECKS
   Both results should be 0.
   ============================================================ */

SELECT
    SUM(CASE
        WHEN od.DateKey IS NULL THEN 1
        ELSE 0
    END) AS InvalidOriginationDates,

    SUM(CASE
        WHEN md.DateKey IS NULL THEN 1
        ELSE 0
    END) AS InvalidMaturityDates

FROM dbo.FactLoans fl

LEFT JOIN dbo.DimDate od
    ON fl.OriginationDateKey = od.DateKey

LEFT JOIN dbo.DimDate md
    ON fl.MaturityDateKey = md.DateKey;
GO


/* ============================================================
   12. LOAN REFERENTIAL-INTEGRITY CHECKS
   ============================================================ */

SELECT COUNT(*) AS InvalidLoanCustomers
FROM dbo.FactLoans fl
LEFT JOIN dbo.DimCustomer dc
    ON fl.CustomerID = dc.CustomerID
WHERE dc.CustomerID IS NULL;
GO

SELECT COUNT(*) AS InvalidLoanBranches
FROM dbo.FactLoans fl
LEFT JOIN dbo.DimBranch db
    ON fl.BranchID = db.BranchID
WHERE db.BranchID IS NULL;
GO

SELECT COUNT(*) AS InvalidLoanTypes
FROM dbo.FactLoans fl
LEFT JOIN dbo.DimLoanType dlt
    ON fl.LoanTypeID = dlt.LoanTypeID
WHERE dlt.LoanTypeID IS NULL;
GO

SELECT COUNT(*) AS InvalidCreditScoreTiers
FROM dbo.FactLoans fl
LEFT JOIN dbo.DimCreditScoreTier dcst
    ON fl.CreditScoreTierID = dcst.CreditScoreTierID
WHERE dcst.CreditScoreTierID IS NULL;
GO


/* ============================================================
   13. FINAL WAREHOUSE SUMMARY
   ============================================================ */

SELECT
    (SELECT COUNT(*) FROM dbo.DimBranch)
        AS Branches,

    (SELECT COUNT(*) FROM dbo.DimCustomer)
        AS Customers,

    (SELECT COUNT(*) FROM dbo.DimAccount)
        AS Accounts,

    (SELECT COUNT(*) FROM dbo.FactTransactions)
        AS Transactions,

    (SELECT COUNT(*) FROM dbo.FactLoans)
        AS Loans;
GO