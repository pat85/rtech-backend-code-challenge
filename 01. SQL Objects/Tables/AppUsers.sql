/* Object: dbo.AppUsers */
IF OBJECT_ID(N'dbo.AppUsers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AppUsers
    (
        UserId      INT IDENTITY(1,1) NOT NULL,
        Username    VARCHAR(100) NOT NULL,
        FullName    NVARCHAR(150) NOT NULL,
        Email       VARCHAR(255) NULL,
        [Role]      VARCHAR(50) NOT NULL,
        IsActive    BIT NOT NULL CONSTRAINT DF_AppUsers_IsActive DEFAULT (1),
        CreatedAt   DATETIME2(0) NOT NULL CONSTRAINT DF_AppUsers_CreatedAt DEFAULT (SYSUTCDATETIME()),
        UpdatedAt   DATETIME2(0) NULL,
        CONSTRAINT PK_AppUsers PRIMARY KEY CLUSTERED (UserId),
        CONSTRAINT UQ_AppUsers_Username UNIQUE (Username)
    );
END;
GO
