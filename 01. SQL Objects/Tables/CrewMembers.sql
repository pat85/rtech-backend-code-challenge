/* Object: dbo.CrewMembers */
IF OBJECT_ID(N'dbo.CrewMembers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CrewMembers
    (
        CrewMemberId VARCHAR(20) NOT NULL,
        FirstName    NVARCHAR(100) NOT NULL,
        LastName     NVARCHAR(100) NOT NULL,
        BirthDate    DATE NOT NULL,
        Nationality  NVARCHAR(100) NOT NULL,
        CreatedAt    DATETIME2(0) NOT NULL CONSTRAINT DF_CrewMembers_CreatedAt DEFAULT (SYSUTCDATETIME()),
        UpdatedAt    DATETIME2(0) NULL,
        CONSTRAINT PK_CrewMembers PRIMARY KEY CLUSTERED (CrewMemberId)
    );
END;
GO
