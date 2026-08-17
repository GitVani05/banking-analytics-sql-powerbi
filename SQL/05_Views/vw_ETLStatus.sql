USE BankingDW;
GO

CREATE OR ALTER VIEW dbo.vw_ETLStatus
AS
SELECT
    ETLLogID,
    ProcedureName,
    StartTime,
    EndTime,
    DATEDIFF(SECOND, StartTime, EndTime) AS DurationSeconds,
    RowsProcessed,
    Status,
    ErrorMessage
FROM dbo.ETLLog;
GO

SELECT *
FROM dbo.vw_ETLStatus
ORDER BY ETLLogID DESC;