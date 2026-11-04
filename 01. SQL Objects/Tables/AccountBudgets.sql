/* Object: dbo.AccountBudgets */
IF OBJECT_ID(N'dbo.AccountBudgets', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AccountBudgets
    (
        BudgetId          BIGINT IDENTITY(1,1) NOT NULL,
        ShipId            INT NOT NULL,
        AccountId         INT NOT NULL,
        AccountingPeriod  DATE NOT NULL, -- Always the first calendar day of the month.
        BudgetValue       DECIMAL(19,4) NOT NULL,
        CreatedAt         DATETIME2(0) NOT NULL CONSTRAINT DF_AccountBudgets_CreatedAt DEFAULT (SYSUTCDATETIME()),
        UpdatedAt         DATETIME2(0) NULL,
        CONSTRAINT PK_AccountBudgets PRIMARY KEY CLUSTERED (BudgetId),
        CONSTRAINT FK_AccountBudgets_Ships FOREIGN KEY (ShipId) REFERENCES dbo.Ships(ShipId),
        CONSTRAINT FK_AccountBudgets_ChartOfAccounts FOREIGN KEY (AccountId) REFERENCES dbo.ChartOfAccounts(AccountId),
        CONSTRAINT CK_AccountBudgets_FirstOfMonth CHECK (DAY(AccountingPeriod) = 1),
        CONSTRAINT CK_AccountBudgets_NonNegative CHECK (BudgetValue >= 0),
        CONSTRAINT UQ_AccountBudgets_Ship_Account_Period UNIQUE (ShipId, AccountId, AccountingPeriod)
    );
END;
GO
