USE BankingDW;
GO

-- =====================================================
-- FactTransactions Indexes
-- Purpose: Improve filtering, joins, and date analysis
-- =====================================================

CREATE NONCLUSTERED INDEX IX_FactTransactions_DateKey
ON dbo.FactTransactions (DateKey);
GO

CREATE NONCLUSTERED INDEX IX_FactTransactions_CustomerID
ON dbo.FactTransactions (CustomerID);
GO

CREATE NONCLUSTERED INDEX IX_FactTransactions_BranchID
ON dbo.FactTransactions (BranchID);
GO

CREATE NONCLUSTERED INDEX IX_FactTransactions_AccountID
ON dbo.FactTransactions (AccountID);
GO


-- =====================================================
-- FactLoans Indexes
-- Purpose: Improve loan portfolio and risk reporting
-- =====================================================

CREATE NONCLUSTERED INDEX IX_FactLoans_OriginationDateKey
ON dbo.FactLoans (OriginationDateKey);
GO

CREATE NONCLUSTERED INDEX IX_FactLoans_MaturityDateKey
ON dbo.FactLoans (MaturityDateKey);
GO

CREATE NONCLUSTERED INDEX IX_FactLoans_LoanTypeID
ON dbo.FactLoans (LoanTypeID);
GO

CREATE NONCLUSTERED INDEX IX_FactLoans_LoanStatus
ON dbo.FactLoans (LoanStatus);
GO

CREATE NONCLUSTERED INDEX IX_FactLoans_CustomerID
ON dbo.FactLoans (CustomerID);
GO

CREATE NONCLUSTERED INDEX IX_FactLoans_CreditScoreTierID
ON dbo.FactLoans (CreditScoreTierID);
GO

CREATE NONCLUSTERED INDEX IX_FactLoans_BranchID
ON dbo.FactLoans (BranchID);
GO