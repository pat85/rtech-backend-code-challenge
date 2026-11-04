/* Object: dbo.UserShips */
IF OBJECT_ID(N'dbo.UserShips', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserShips
    (
        UserId      INT NOT NULL,
        ShipId      INT NOT NULL,
        AssignedAt  DATETIME2(0) NOT NULL CONSTRAINT DF_UserShips_AssignedAt DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_UserShips PRIMARY KEY CLUSTERED (UserId, ShipId),
        CONSTRAINT FK_UserShips_AppUsers FOREIGN KEY (UserId) REFERENCES dbo.AppUsers(UserId),
        CONSTRAINT FK_UserShips_Ships FOREIGN KEY (ShipId) REFERENCES dbo.Ships(ShipId)
    );
END;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.UserShips') AND name = N'IX_UserShips_ShipId_UserId')
    CREATE INDEX IX_UserShips_ShipId_UserId ON dbo.UserShips(ShipId, UserId);
GO
