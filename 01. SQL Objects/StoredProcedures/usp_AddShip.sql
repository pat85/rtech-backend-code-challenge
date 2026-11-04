/* Object: dbo.usp_AddShip */
CREATE OR ALTER PROCEDURE dbo.usp_AddShip
    @ShipCode VARCHAR(20), @ShipName NVARCHAR(150),
    @FiscalYearStartMonth TINYINT, @FiscalYearEndMonth TINYINT,
    @IsActive BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @ShipCode = NULLIF(LTRIM(RTRIM(@ShipCode)), '');
    SET @ShipName = NULLIF(LTRIM(RTRIM(@ShipName)), N'');
    IF @ShipCode IS NULL OR @ShipName IS NULL
        THROW 50111, 'ShipCode and ShipName are required.', 1;
    IF @FiscalYearStartMonth NOT BETWEEN 1 AND 12 OR @FiscalYearEndMonth NOT BETWEEN 1 AND 12
        THROW 50112, 'Fiscal year months must be between 1 and 12.', 1;
    IF @FiscalYearEndMonth <> CASE WHEN @FiscalYearStartMonth = 1 THEN 12 ELSE @FiscalYearStartMonth - 1 END
        THROW 50113, 'Fiscal year must span 12 months; end month must be the month before start month.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Ships WHERE ShipCode = @ShipCode)
        THROW 50114, 'ShipCode already exists.', 1;
    INSERT dbo.Ships(ShipCode, ShipName, FiscalYearStartMonth, FiscalYearEndMonth, IsActive)
    VALUES (@ShipCode, @ShipName, @FiscalYearStartMonth, @FiscalYearEndMonth, @IsActive);
    SELECT ShipId, ShipCode, ShipName, FiscalYearStartMonth, FiscalYearEndMonth, IsActive
    FROM dbo.Ships WHERE ShipId = CONVERT(int, SCOPE_IDENTITY());
END;
GO
