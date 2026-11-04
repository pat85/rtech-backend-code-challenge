/* Object: dbo.usp_AssignShipToUser */
CREATE OR ALTER PROCEDURE dbo.usp_AssignShipToUser
    @UserId INT, @ShipId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.AppUsers WITH (UPDLOCK, HOLDLOCK) WHERE UserId = @UserId AND IsActive = 1)
            THROW 50121, 'Active user was not found.', 1;
        IF NOT EXISTS (SELECT 1 FROM dbo.Ships WITH (UPDLOCK, HOLDLOCK) WHERE ShipId = @ShipId AND IsActive = 1)
            THROW 50122, 'Active ship was not found.', 1;
        IF NOT EXISTS (SELECT 1 FROM dbo.UserShips WITH (UPDLOCK, HOLDLOCK) WHERE UserId = @UserId AND ShipId = @ShipId)
            INSERT dbo.UserShips(UserId, ShipId) VALUES (@UserId, @ShipId);
        COMMIT TRANSACTION;
        SELECT us.UserId, u.Username, us.ShipId, s.ShipCode, s.ShipName, us.AssignedAt
        FROM dbo.UserShips us
        INNER JOIN dbo.AppUsers u ON u.UserId = us.UserId
        INNER JOIN dbo.Ships s ON s.ShipId = us.ShipId
        WHERE us.UserId = @UserId AND us.ShipId = @ShipId;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
