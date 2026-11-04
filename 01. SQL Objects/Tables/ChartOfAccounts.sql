/* Object: dbo.ChartOfAccounts */
IF OBJECT_ID(N'dbo.ChartOfAccounts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChartOfAccounts
    (
        AccountId        INT IDENTITY(1,1) NOT NULL,
        AccountNumber    VARCHAR(20) NOT NULL,
        AccountName      NVARCHAR(200) NOT NULL,
        ParentAccountId  INT NULL,
        IsPostingAccount BIT NOT NULL CONSTRAINT DF_ChartOfAccounts_IsPostingAccount DEFAULT (0),
        IsActive         BIT NOT NULL CONSTRAINT DF_ChartOfAccounts_IsActive DEFAULT (1),
        CreatedAt        DATETIME2(0) NOT NULL CONSTRAINT DF_ChartOfAccounts_CreatedAt DEFAULT (SYSUTCDATETIME()),
        UpdatedAt        DATETIME2(0) NULL,
        CONSTRAINT PK_ChartOfAccounts PRIMARY KEY CLUSTERED (AccountId),
        CONSTRAINT UQ_ChartOfAccounts_AccountNumber UNIQUE (AccountNumber),
        CONSTRAINT FK_ChartOfAccounts_Parent FOREIGN KEY (ParentAccountId) REFERENCES dbo.ChartOfAccounts(AccountId),
        CONSTRAINT CK_ChartOfAccounts_NotOwnParent CHECK (ParentAccountId IS NULL OR ParentAccountId <> AccountId)
    );
END;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ChartOfAccounts') AND name = N'IX_ChartOfAccounts_ParentAccountId')
    CREATE INDEX IX_ChartOfAccounts_ParentAccountId ON dbo.ChartOfAccounts(ParentAccountId) INCLUDE (AccountNumber, AccountName, IsPostingAccount, IsActive);
GO
