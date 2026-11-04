/* Object: dbo.CrewRanks */
IF OBJECT_ID(N'dbo.CrewRanks', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CrewRanks
    (
        RankId          INT IDENTITY(1,1) NOT NULL,
        RankName        NVARCHAR(100) NOT NULL,
        RankDescription NVARCHAR(255) NULL,
        DisplayOrder    INT NOT NULL CONSTRAINT DF_CrewRanks_DisplayOrder DEFAULT (0),
        IsActive        BIT NOT NULL CONSTRAINT DF_CrewRanks_IsActive DEFAULT (1),
        CONSTRAINT PK_CrewRanks PRIMARY KEY CLUSTERED (RankId),
        CONSTRAINT UQ_CrewRanks_RankName UNIQUE (RankName)
    );
END;
GO
