USE BankingDW;
GO

CREATE OR ALTER PROCEDURE dbo.usp_LogETLExecution
(
    @ProcedureName VARCHAR(100),
    @StartTime DATETIME2,
    @EndTime DATETIME2,
    @RowsProcessed INT,
    @Status VARCHAR(20),
    @ErrorMessage VARCHAR(1000) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.ETLLog
    (
        ProcedureName,
        StartTime,
        EndTime,
        RowsProcessed,
        Status,
        ErrorMessage
    )
    VALUES
    (
        @ProcedureName,
        @StartTime,
        @EndTime,
        @RowsProcessed,
        @Status,
        @ErrorMessage
    );
END;
GO

DECLARE @Start DATETIME2 = DATEADD(SECOND, -5, SYSDATETIME());
DECLARE @End DATETIME2 = SYSDATETIME();

EXEC dbo.usp_LogETLExecution
     @ProcedureName = 'Load FactTransactions',
     @StartTime = @Start,
     @EndTime = @End,
     @RowsProcessed = 1000000,
     @Status = 'Success',
     @ErrorMessage = NULL;

SELECT *
FROM dbo.ETLLog;

--Simulate a Failed Load
DECLARE @Start DATETIME2 = DATEADD(SECOND, -2, SYSDATETIME());
DECLARE @End DATETIME2 = SYSDATETIME();

EXEC dbo.usp_LogETLExecution
     @ProcedureName = 'Load FactLoans',
     @StartTime = @Start,
     @EndTime = @End,
     @RowsProcessed = 0,
     @Status = 'Failed',
     @ErrorMessage = 'Primary key violation while loading FactLoans.';

SELECT *
FROM dbo.ETLLog
ORDER BY ETLLogID DESC;