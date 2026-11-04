/*
    Seed: Ships
    Five vessels with mixed operational status and fiscal-year calendars.
    Idempotent: existing ShipCode rows are left unchanged.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

INSERT INTO dbo.Ships (ShipCode, ShipName, FiscalYearStartMonth, FiscalYearEndMonth, IsActive)
SELECT v.ShipCode, v.ShipName, v.FiscalYearStartMonth, v.FiscalYearEndMonth, v.IsActive
FROM (VALUES
('SHIP01', N'Flying Dutchman', 1, 12, 1),
('SHIP02', N'Thousand Sunny', 4, 3, 1),
('SHIP03', N'Black Pearl', 4, 3, 1),
('SHIP04', N'Queen Anne''s Revenge', 10, 9, 0),
('SHIP05', N'Nautilus', 1, 12, 1)
) AS v(ShipCode, ShipName, FiscalYearStartMonth, FiscalYearEndMonth, IsActive)
WHERE NOT EXISTS (SELECT 1 FROM dbo.Ships s WHERE s.ShipCode = v.ShipCode);

COMMIT TRANSACTION;
GO
