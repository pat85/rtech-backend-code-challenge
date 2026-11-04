/* Shared report pattern: monthly values are for @AccountingPeriod; YTD starts at the
   ship's configured fiscal-year start month. Parent COA values include all descendant
   posting accounts. A missing value remains NULL; explicit zero-only rows are omitted. */
/* Object: dbo.usp_GetFinancialReportSummary
   Summary is grouped by top-level COA account. */
CREATE OR ALTER PROCEDURE dbo.usp_GetFinancialReportSummary
    @ShipCode          VARCHAR(20),
    @AccountingPeriod DATE
AS
BEGIN
    SET NOCOUNT ON;
    IF DAY(@AccountingPeriod) <> 1
        THROW 50021, 'AccountingPeriod must be the first day of a month.', 1;

    DECLARE @ShipId INT, @StartMonth TINYINT, @FiscalStart DATE;
    SELECT @ShipId = ShipId, @StartMonth = FiscalYearStartMonth
    FROM dbo.Ships WHERE ShipCode = @ShipCode AND IsActive = 1;
    IF @ShipId IS NULL THROW 50022, 'Ship was not found or is inactive.', 1;

    SET @FiscalStart = DATEFROMPARTS(
        CASE WHEN MONTH(@AccountingPeriod) >= @StartMonth THEN YEAR(@AccountingPeriod) ELSE YEAR(@AccountingPeriod) - 1 END,
        @StartMonth, 1);

    ;WITH PostingAccounts AS
    (
        SELECT AccountId FROM dbo.ChartOfAccounts WHERE IsActive = 1 AND IsPostingAccount = 1
    ),
    AccountRoots AS
    (
        SELECT p.AccountId AS PostingAccountId, a.AccountId AS RootAccountId, a.ParentAccountId
        FROM PostingAccounts p
        INNER JOIN dbo.ChartOfAccounts a ON a.AccountId = p.AccountId
        UNION ALL
        SELECT ar.PostingAccountId, parent.AccountId, parent.ParentAccountId
        FROM AccountRoots ar
        INNER JOIN dbo.ChartOfAccounts parent ON parent.AccountId = ar.ParentAccountId
    ),
    RootForPosting AS
    (
        SELECT PostingAccountId, RootAccountId
        FROM AccountRoots
        WHERE ParentAccountId IS NULL
    ),
    MonthlyActual AS
    (
        SELECT AccountId, SUM(ActualValue) AS Amount
        FROM dbo.AccountTransactions
        WHERE ShipId = @ShipId AND AccountingPeriod = @AccountingPeriod
        GROUP BY AccountId
    ),
    MonthlyBudget AS
    (
        SELECT AccountId, SUM(BudgetValue) AS Amount
        FROM dbo.AccountBudgets
        WHERE ShipId = @ShipId AND AccountingPeriod = @AccountingPeriod
        GROUP BY AccountId
    ),
    YtdActual AS
    (
        SELECT AccountId, SUM(ActualValue) AS Amount
        FROM dbo.AccountTransactions
        WHERE ShipId = @ShipId AND AccountingPeriod BETWEEN @FiscalStart AND @AccountingPeriod
        GROUP BY AccountId
    ),
    YtdBudget AS
    (
        SELECT AccountId, SUM(BudgetValue) AS Amount
        FROM dbo.AccountBudgets
        WHERE ShipId = @ShipId AND AccountingPeriod BETWEEN @FiscalStart AND @AccountingPeriod
        GROUP BY AccountId
    )
    SELECT
        root.AccountNumber,
        root.AccountName AS COADescription,
        SUM(ma.Amount) AS ActualValue,
        SUM(mb.Amount) AS BudgetValue,
        CASE WHEN SUM(ma.Amount) IS NULL AND SUM(mb.Amount) IS NULL THEN NULL
             ELSE COALESCE(SUM(ma.Amount), 0) - COALESCE(SUM(mb.Amount), 0) END AS Variance,
        SUM(ya.Amount) AS ActualYTD,
        SUM(yb.Amount) AS BudgetYTD,
        CASE WHEN SUM(ya.Amount) IS NULL AND SUM(yb.Amount) IS NULL THEN NULL
             ELSE COALESCE(SUM(ya.Amount), 0) - COALESCE(SUM(yb.Amount), 0) END AS VarianceYTD
    FROM RootForPosting rp
    INNER JOIN dbo.ChartOfAccounts root ON root.AccountId = rp.RootAccountId
    LEFT JOIN MonthlyActual ma ON ma.AccountId = rp.PostingAccountId
    LEFT JOIN MonthlyBudget mb ON mb.AccountId = rp.PostingAccountId
    LEFT JOIN YtdActual ya ON ya.AccountId = rp.PostingAccountId
    LEFT JOIN YtdBudget yb ON yb.AccountId = rp.PostingAccountId
    GROUP BY root.AccountId, root.AccountNumber, root.AccountName
    HAVING COALESCE(SUM(ma.Amount), 0) <> 0
        OR COALESCE(SUM(mb.Amount), 0) <> 0
        OR COALESCE(SUM(ya.Amount), 0) <> 0
        OR COALESCE(SUM(yb.Amount), 0) <> 0
    ORDER BY root.AccountNumber
    OPTION (MAXRECURSION 100);
END;
GO
