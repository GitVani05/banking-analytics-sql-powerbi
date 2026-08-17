USE BankingDW;
GO

CREATE TABLE dbo.FactLoans
(
    LoanID BIGINT IDENTITY(1,1) PRIMARY KEY,

    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    LoanTypeID INT NOT NULL,
    CreditScoreTierID INT NOT NULL,

    OriginationDateKey INT NOT NULL,
    MaturityDateKey INT NOT NULL,

    LoanAmount DECIMAL(18,2) NOT NULL,
    OutstandingBalance DECIMAL(18,2) NOT NULL,

    InterestRate DECIMAL(5,2) NOT NULL,
    TermMonths INT NOT NULL,

    MonthlyPayment DECIMAL(18,2) NOT NULL,

    DaysPastDue INT NOT NULL,

    LoanStatus VARCHAR(20) NOT NULL,

    IsNonPerforming BIT NOT NULL,

    CONSTRAINT FK_FactLoans_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES dbo.DimCustomer(CustomerID),

    CONSTRAINT FK_FactLoans_Branch
        FOREIGN KEY (BranchID)
        REFERENCES dbo.DimBranch(BranchID),

    CONSTRAINT FK_FactLoans_LoanType
        FOREIGN KEY (LoanTypeID)
        REFERENCES dbo.DimLoanType(LoanTypeID),

    CONSTRAINT FK_FactLoans_CreditScoreTier
        FOREIGN KEY (CreditScoreTierID)
        REFERENCES dbo.DimCreditScoreTier(CreditScoreTierID),

    CONSTRAINT FK_FactLoans_OriginationDate
        FOREIGN KEY (OriginationDateKey)
        REFERENCES dbo.DimDate(DateKey),

    CONSTRAINT FK_FactLoans_MaturityDate
        FOREIGN KEY (MaturityDateKey)
        REFERENCES dbo.DimDate(DateKey)
);
GO

EXEC sp_help 'dbo.FactLoans';

SELECT *
FROM dbo.DimLoanType;

SELECT *
FROM dbo.DimCreditScoreTier;

