/* Object: dbo.usp_GetShips */
CREATE OR ALTER PROCEDURE dbo.usp_GetShips
    @IncludeInactive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ShipId, ShipCode, ShipName, FiscalYearStartMonth, FiscalYearEndMonth, IsActive
    FROM dbo.Ships
    WHERE @IncludeInactive = 1 OR IsActive = 1
    ORDER BY ShipName, ShipCode;
END;
GO
