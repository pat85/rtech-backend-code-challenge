/*
    Seed: UserShips
    User and ship identities are resolved by their natural keys.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

INSERT INTO dbo.UserShips (UserId, ShipId)
SELECT u.UserId, s.ShipId
FROM (VALUES
('admin', 'SHIP01'),
('admin', 'SHIP02'),
('admin', 'SHIP03'),
('admin', 'SHIP04'),
('admin', 'SHIP05'),
('ops.manager', 'SHIP01'),
('ops.manager', 'SHIP02'),
('ops.manager', 'SHIP03'),
('crew.manager', 'SHIP01'),
('crew.manager', 'SHIP02'),
('crew.manager', 'SHIP03'),
('finance.analyst', 'SHIP01'),
('finance.analyst', 'SHIP02'),
('finance.analyst', 'SHIP03'),
('ship.viewer', 'SHIP01'),
('ship.viewer', 'SHIP02')
) AS v(Username, ShipCode)
JOIN dbo.AppUsers u ON u.Username = v.Username
JOIN dbo.Ships s ON s.ShipCode = v.ShipCode
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.UserShips us
    WHERE us.UserId = u.UserId AND us.ShipId = s.ShipId
);

COMMIT TRANSACTION;
GO
