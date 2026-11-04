/* Object: dbo.usp_GetShipsByUser */
CREATE OR ALTER PROCEDURE dbo.usp_GetShipsByUser
    @UserId INT, @IncludeInactiveShips BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.AppUsers WHERE UserId = @UserId AND IsActive = 1)
        THROW 50131, 'Active user was not found.', 1;
    SELECT s.ShipId, s.ShipCode, s.ShipName, s.FiscalYearStartMonth,
           s.FiscalYearEndMonth, s.IsActive, us.AssignedAt
    FROM dbo.UserShips us
    INNER JOIN dbo.Ships s ON s.ShipId = us.ShipId
    WHERE us.UserId = @UserId
      AND (@IncludeInactiveShips = 1 OR s.IsActive = 1)
    ORDER BY s.ShipName, s.ShipCode;
END;
GO
