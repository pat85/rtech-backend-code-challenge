/* Object: dbo.usp_GetUsers */
CREATE OR ALTER PROCEDURE dbo.usp_GetUsers
    @IncludeInactive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.UserId, u.Username, u.FullName, u.Email, u.[Role], u.IsActive, u.CreatedAt,
           COUNT(us.ShipId) AS AssignedShipCount
    FROM dbo.AppUsers u
    LEFT JOIN dbo.UserShips us ON us.UserId = u.UserId
    WHERE @IncludeInactive = 1 OR u.IsActive = 1
    GROUP BY u.UserId, u.Username, u.FullName, u.Email, u.[Role], u.IsActive, u.CreatedAt
    ORDER BY u.FullName, u.UserId;
END;
GO
