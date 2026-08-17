USE BankingDW;
GO

CREATE OR ALTER FUNCTION dbo.fn_DelinquencyRate()
RETURNS DECIMAL(5,2)
AS
BEGIN

    DECLARE @Rate DECIMAL(5,2);

    SELECT

        @Rate = CAST(

            SUM(
                CASE
                    WHEN LoanStatus='Delinquent'
                    THEN 1
                    ELSE 0
                END
            )*100.0

            /COUNT(*)

        AS DECIMAL(5,2))

    FROM dbo.vw_CreditRisk;

    RETURN @Rate;

END
GO

SELECT dbo.fn_DelinquencyRate();