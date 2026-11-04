/* Object: dbo.AccountTransactions */
IF OBJECT_ID(N'dbo.AccountTransactions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AccountTransactions
    (
        TransactionId     BIGINT IDENTITY(1,1) NOT NULL,
        ShipId            INT NOT NULL,
        AccountId         INT NOT NULL,
        AccountingPeriod  DATE NOT NULL, -- First calendar day of the accounting month.
        TransactionDate   DATE NOT NULL,
        Description       NVARCHAR(255) NULL,
        ActualValue       DECIMAL(19,4) NOT NULL,
        CreatedAt         DATETIME2(0) NOT NULL CONSTRAINT DF_AccountTransactions_CreatedAt DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_AccountTransactions PRIMARY KEY CLUSTERED (TransactionId),
        CONSTRAINT FK_AccountTransactions_Ships FOREIGN KEY (ShipId) REFERENCES dbo.Ships(ShipId),
        CONSTRAINT FK_AccountTransactions_ChartOfAccounts FOREIGN KEY (AccountId) REFERENCES dbo.ChartOfAccounts(AccountId),
        CONSTRAINT CK_AccountTransactions_FirstOfMonth CHECK (DAY(AccountingPeriod) = 1),
        CONSTRAINT CK_AccountTransactions_NonNegative CHECK (ActualValue >= 0)
    );
END;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.AccountTransactions') AND name = N'IX_AccountTransactions_Ship_Account_Period')
    CREATE INDEX IX_AccountTransactions_Ship_Account_Period ON dbo.AccountTransactions(ShipId, AccountId, AccountingPeriod) INCLUDE (ActualValue);
GO
