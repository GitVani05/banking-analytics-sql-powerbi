USE BankingDW;
GO

CREATE TABLE dbo.ETLLog
(
    ETLLogID INT IDENTITY(1,1) PRIMARY KEY,

    ProcedureName VARCHAR(100) NOT NULL,

    StartTime DATETIME2 NOT NULL,

    EndTime DATETIME2 NULL,

    RowsProcessed INT NULL,

    Status VARCHAR(20) NOT NULL,

    ErrorMessage VARCHAR(1000) NULL
);
GO

SELECT *
FROM dbo.ETLLog;