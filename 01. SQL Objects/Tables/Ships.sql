/* Object: dbo.Ships */
IF OBJECT_ID(N'dbo.Ships', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Ships
    (
        ShipId                  INT IDENTITY(1,1) NOT NULL,
        ShipCode                VARCHAR(20) NOT NULL,
        ShipName                NVARCHAR(150) NOT NULL,
        FiscalYearStartMonth    TINYINT NOT NULL,
        FiscalYearEndMonth      TINYINT NOT NULL,
        IsActive                BIT NOT NULL CONSTRAINT DF_Ships_IsActive DEFAULT (1),
        CreatedAt               DATETIME2(0) NOT NULL CONSTRAINT DF_Ships_CreatedAt DEFAULT (SYSUTCDATETIME()),
        UpdatedAt               DATETIME2(0) NULL,
        CONSTRAINT PK_Ships PRIMARY KEY CLUSTERED (ShipId),
        CONSTRAINT UQ_Ships_ShipCode UNIQUE (ShipCode),
        CONSTRAINT CK_Ships_FiscalYearStartMonth CHECK (FiscalYearStartMonth BETWEEN 1 AND 12),
        CONSTRAINT CK_Ships_FiscalYearEndMonth CHECK (FiscalYearEndMonth BETWEEN 1 AND 12)
    );
END;
GO
