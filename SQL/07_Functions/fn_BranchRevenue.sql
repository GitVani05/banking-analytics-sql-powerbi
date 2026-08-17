USE BankingDW;
GO

CREATE OR ALTER FUNCTION dbo.fn_BranchRevenue
(
    @BranchID INT
)

RETURNS MONEY
AS
BEGIN

    DECLARE @Revenue MONEY;

    SELECT

        @Revenue = SUM(RevenueAmount)

    FROM dbo.vw_ExecutiveOperations

    WHERE BranchID=@BranchID;

    RETURN ISNULL(@Revenue,0);

END
GO

SELECT

BranchID,

BranchName,

dbo.fn_BranchRevenue(BranchID)

FROM dbo.DimBranch;