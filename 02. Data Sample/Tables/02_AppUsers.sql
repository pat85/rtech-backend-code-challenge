/*
    Seed: AppUsers
    Demo-only identities; production authentication credentials are intentionally not included.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

INSERT INTO dbo.AppUsers (Username, FullName, Email, [Role], IsActive)
SELECT v.Username, v.FullName, v.Email, v.[Role], 1
FROM (VALUES
('admin', N'System Administrator', 'admin@example.test', 'Admin'),
('ops.manager', N'Olivia Morgan', 'olivia.morgan@example.test', 'Manager'),
('crew.manager', N'Noah Williams', 'noah.williams@example.test', 'CrewManager'),
('finance.analyst', N'Emma Taylor', 'emma.taylor@example.test', 'Finance'),
('ship.viewer', N'Liam Brown', 'liam.brown@example.test', 'Viewer')
) AS v(Username, FullName, Email, [Role])
WHERE NOT EXISTS (SELECT 1 FROM dbo.AppUsers u WHERE u.Username = v.Username);

COMMIT TRANSACTION;
GO
