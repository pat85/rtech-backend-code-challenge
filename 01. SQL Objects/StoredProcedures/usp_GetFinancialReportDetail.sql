/* Shared report pattern: monthly values are for @AccountingPeriod; YTD starts at the
   ship's configured fiscal-year start month. Parent COA values include all descendant
   posting accounts. A missing value remains NULL; explicit zero-only rows are omitted. */
/* Object: dbo.usp_GetFinancialReportDetail */
CREATE OR ALTER PROCEDURE dbo.usp_GetFinancialReportDetail
    @ShipCode          VARCHAR(20),
    @AccountingPeriod DATE
AS
BEGIN
    SET NOCOUNT ON;
    IF DAY(@AccountingPeriod) <> 1
        THROW 50011, 'AccountingPeriod must be the first day of a month.', 1;

    DECLARE @ShipId INT, @StartMonth TINYINT, @FiscalStart DATE;
    SELECT @ShipId = ShipId, @StartMonth = FiscalYearStartMonth
    FROM dbo.Ships WHERE ShipCode = @ShipCode AND IsActive = 1;
    IF @ShipId IS NULL THROW 50012, 'Ship was not found or is inactive.', 1;

    SET @FiscalStart = DATEFROMPARTS(
        CASE WHEN MONTH(@AccountingPeriod) >= @StartMonth THEN YEAR(@AccountingPeriod) ELSE YEAR(@AccountingPeriod) - 1 END,
        @StartMonth, 1);

    ;WITH PostingAccounts AS
    (
        SELECT AccountId, AccountNumber, AccountName, ParentAccountId
        FROM dbo.ChartOfAccounts WHERE IsActive = 1 AND IsPostingAccount = 1
    ),
    AccountAncestors AS
    (
        SELECT p.AccountId AS PostingAccountId, p.AccountId AS ReportAccountId
        FROM PostingAccounts p
        UNION ALL
        SELECT aa.PostingAccountId, parent.ParentAccountId
        FROM AccountAncestors aa
        INNER JOIN dbo.ChartOfAccounts parent ON parent.AccountId = aa.ReportAccountId
        WHERE parent.ParentAccountId IS NOT NULL
    ),
    MonthlyActual AS
    (
        SELECT AccountId, SUM(ActualValue) AS ActualValue
        FROM dbo.AccountTransactions
        WHERE ShipId = @ShipId AND AccountingPeriod = @AccountingPeriod
        GROUP BY AccountId
    ),
    MonthlyBudget AS
    (
        SELECT AccountId, SUM(BudgetValue) AS BudgetValue
        FROM dbo.AccountBudgets
        WHERE ShipId = @ShipId AND AccountingPeriod = @AccountingPeriod
        GROUP BY AccountId
    ),
    YtdActual AS
    (
        SELECT AccountId, SUM(ActualValue) AS ActualValue
        FROM dbo.AccountTransactions
        WHERE ShipId = @ShipId AND AccountingPeriod >= @FiscalStart AND AccountingPeriod <= @AccountingPeriod
        GROUP BY AccountId
    ),
    YtdBudget AS
    (
        SELECT AccountId, SUM(BudgetValue) AS BudgetValue
        FROM dbo.AccountBudgets
        WHERE ShipId = @ShipId AND AccountingPeriod >= @FiscalStart AND AccountingPeriod <= @AccountingPeriod
        GROUP BY AccountId
    ),
    Expanded AS
    (
        SELECT
            aa.ReportAccountId,
            SUM(ma.ActualValue) AS MonthlyActual,
            SUM(mb.BudgetValue) AS MonthlyBudget,
            SUM(ya.ActualValue) AS YtdActual,
            SUM(yb.BudgetValue) AS YtdBudget
        FROM AccountAncestors aa
        LEFT JOIN MonthlyActual ma ON ma.AccountId = aa.PostingAccountId
        LEFT JOIN MonthlyBudget mb ON mb.AccountId = aa.PostingAccountId
        LEFT JOIN YtdActual ya ON ya.AccountId = aa.PostingAccountId
        LEFT JOIN YtdBudget yb ON yb.AccountId = aa.PostingAccountId
        GROUP BY aa.ReportAccountId
    )
    SELECT
        coa.AccountName AS COADescription,
        coa.AccountNumber,
        e.MonthlyActual AS ActualValue,
        e.MonthlyBudget AS BudgetValue,
        CASE WHEN e.MonthlyActual IS NULL AND e.MonthlyBudget IS NULL THEN NULL
             ELSE COALESCE(e.MonthlyActual, 0) - COALESCE(e.MonthlyBudget, 0) END AS Variance,
        e.YtdActual AS ActualYTD,
        e.YtdBudget AS BudgetYTD,
        CASE WHEN e.YtdActual IS NULL AND e.YtdBudget IS NULL THEN NULL
             ELSE COALESCE(e.YtdActual, 0) - COALESCE(e.YtdBudget, 0) END AS VarianceYTD
    FROM Expanded e
    INNER JOIN dbo.ChartOfAccounts coa ON coa.AccountId = e.ReportAccountId
    WHERE COALESCE(e.MonthlyActual, 0) <> 0
       OR COALESCE(e.MonthlyBudget, 0) <> 0
       OR COALESCE(e.YtdActual, 0) <> 0
       OR COALESCE(e.YtdBudget, 0) <> 0
    ORDER BY coa.AccountNumber
    OPTION (MAXRECURSION 100);
END;
GO
