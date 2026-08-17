USE BankingDW;
GO

CREATE OR ALTER FUNCTION dbo.fn_TotalExposure()
RETURNS MONEY
AS
BEGIN

    DECLARE @Exposure MONEY;

    SELECT

        @Exposure = SUM(OutstandingBalance)

    FROM dbo.vw_CreditRisk;

    RETURN @Exposure;

END
GO

SELECT dbo.fn_TotalExposure();