USE BankingDW;
GO

DECLARE @CurrentDate DATE;
DECLARE @EndDate DATE = '2065-12-31';

SELECT @CurrentDate = DATEADD(DAY, 1, MAX(FullDate))
FROM dbo.DimDate;

WHILE @CurrentDate <= @EndDate
BEGIN

    INSERT INTO dbo.DimDate
    (
        DateKey,
        FullDate,
        DayNumber,
        DayName,
        WeekNumber,
        MonthNumber,
        MonthName,
        QuarterNumber,
        QuarterName,
        YearNumber,
        MonthYear
    )
    VALUES
    (
        CONVERT(INT, CONVERT(CHAR(8), @CurrentDate, 112)),
        @CurrentDate,
        DAY(@CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        DATEPART(WEEK, @CurrentDate),
        MONTH(@CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DATEPART(QUARTER, @CurrentDate),
        CONCAT('Q', DATEPART(QUARTER, @CurrentDate)),
        YEAR(@CurrentDate),
        FORMAT(@CurrentDate,'MMM yyyy')
    );

    SET @CurrentDate = DATEADD(DAY,1,@CurrentDate);

END
GO

SELECT
    MIN(FullDate) AS FirstDate,
    MAX(FullDate) AS LastDate,
    COUNT(*) AS TotalDates
FROM dbo.DimDate;

SELECT
    SUM(CASE WHEN d1.DateKey IS NULL THEN 1 ELSE 0 END) AS InvalidOriginationDates,
    SUM(CASE WHEN d2.DateKey IS NULL THEN 1 ELSE 0 END) AS InvalidMaturityDates
FROM dbo.StgFactLoans l
LEFT JOIN dbo.DimDate d1
    ON l.OriginationDateKey = d1.DateKey
LEFT JOIN dbo.DimDate d2
    ON l.MaturityDateKey = d2.DateKey;


SELECT COUNT(*) AS LoanCount
FROM dbo.FactLoans;

CREATE INDEX IX_FactLoans_CustomerID
ON dbo.FactLoans(CustomerID);
GO

CREATE INDEX IX_FactLoans_BranchID
ON dbo.FactLoans(BranchID);
GO

CREATE INDEX IX_FactLoans_LoanTypeID
ON dbo.FactLoans(LoanTypeID);
GO

CREATE INDEX IX_FactLoans_CreditScoreTierID
ON dbo.FactLoans(CreditScoreTierID);
GO

CREATE INDEX IX_FactLoans_OriginationDateKey
ON dbo.FactLoans(OriginationDateKey);
GO

CREATE INDEX IX_FactLoans_MaturityDateKey
ON dbo.FactLoans(MaturityDateKey);
GO

CREATE INDEX IX_FactLoans_LoanStatus
ON dbo.FactLoans(LoanStatus);
GO

SELECT
    (SELECT COUNT(*) FROM dbo.DimCustomer) AS Customers,
    (SELECT COUNT(*) FROM dbo.DimBranch) AS Branches,
    (SELECT COUNT(*) FROM dbo.DimAccount) AS Accounts,
    (SELECT COUNT(*) FROM dbo.FactTransactions) AS Transactions,
    (SELECT COUNT(*) FROM dbo.FactLoans) AS Loans;