/* Object: dbo.CrewServices */
IF OBJECT_ID(N'dbo.CrewServices', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CrewServices
    (
        CrewServiceId     BIGINT IDENTITY(1,1) NOT NULL,
        CrewMemberId      VARCHAR(20) NOT NULL,
        ShipId            INT NOT NULL,
        RankId            INT NOT NULL,
        SignOnDate        DATE NOT NULL,
        SignOffDate       DATE NULL,
        EndOfContractDate DATE NOT NULL,
        CreatedAt         DATETIME2(0) NOT NULL CONSTRAINT DF_CrewServices_CreatedAt DEFAULT (SYSUTCDATETIME()),
        UpdatedAt         DATETIME2(0) NULL,
        CONSTRAINT PK_CrewServices PRIMARY KEY CLUSTERED (CrewServiceId),
        CONSTRAINT FK_CrewServices_CrewMembers FOREIGN KEY (CrewMemberId) REFERENCES dbo.CrewMembers(CrewMemberId),
        CONSTRAINT FK_CrewServices_Ships FOREIGN KEY (ShipId) REFERENCES dbo.Ships(ShipId),
        CONSTRAINT FK_CrewServices_CrewRanks FOREIGN KEY (RankId) REFERENCES dbo.CrewRanks(RankId),
        CONSTRAINT CK_CrewServices_SignOffAfterSignOn CHECK (SignOffDate IS NULL OR SignOffDate >= SignOnDate),
        CONSTRAINT CK_CrewServices_ContractEndAfterSignOn CHECK (EndOfContractDate >= SignOnDate)
    );
END;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.CrewServices') AND name = N'IX_CrewServices_Ship_Dates')
    CREATE INDEX IX_CrewServices_Ship_Dates ON dbo.CrewServices(ShipId, SignOnDate, EndOfContractDate) INCLUDE (CrewMemberId, RankId, SignOffDate);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.CrewServices') AND name = N'IX_CrewServices_CrewMember_SignOn')
    CREATE INDEX IX_CrewServices_CrewMember_SignOn ON dbo.CrewServices(CrewMemberId, SignOnDate DESC);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.CrewServices') AND name = N'IX_CrewServices_Ship_Rank_Dates')
    CREATE INDEX IX_CrewServices_Ship_Rank_Dates ON dbo.CrewServices(ShipId, RankId, SignOnDate, SignOffDate);
GO
