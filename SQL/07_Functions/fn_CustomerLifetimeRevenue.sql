USE BankingDW;
GO

CREATE OR ALTER FUNCTION dbo.fn_CustomerLifetimeRevenue
(
    @CustomerID INT
)

RETURNS MONEY
AS
BEGIN

    DECLARE @Revenue MONEY;

    SELECT

        @Revenue = SUM(RevenueAmount)

    FROM dbo.vw_ExecutiveOperations

    WHERE CustomerID=@CustomerID;

    RETURN ISNULL(@Revenue,0);

END
GO

SELECT

TOP 20

CustomerID,

CustomerName,

dbo.fn_CustomerLifetimeRevenue(CustomerID)

AS LifetimeRevenue

FROM dbo.vw_CustomerAnalytics;