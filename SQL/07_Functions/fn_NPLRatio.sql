USE BankingDW;
GO

CREATE OR ALTER FUNCTION dbo.fn_NPLRatio()
RETURNS DECIMAL(5,2)
AS
BEGIN

    DECLARE @Ratio DECIMAL(5,2);

    SELECT

        @Ratio = CAST(

            SUM(CAST(IsNonPerforming AS INT))*100.0

            /COUNT(*)

        AS DECIMAL(5,2))

    FROM dbo.vw_CreditRisk;

    RETURN @Ratio;

END
GO

SELECT dbo.fn_NPLRatio() AS NPLRatio;