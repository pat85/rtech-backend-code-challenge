/* Object: dbo.vw_ChartOfAccountsHierarchy
   Returns each account with its ancestors' path and hierarchy depth. */
CREATE OR ALTER VIEW dbo.vw_ChartOfAccountsHierarchy
AS
WITH AccountTree AS
(
    SELECT
        a.AccountId,
        a.AccountNumber,
        a.AccountName,
        a.ParentAccountId,
        a.IsPostingAccount,
        a.IsActive,
        CAST(0 AS INT) AS HierarchyLevel,
        CAST('/' + CONVERT(varchar(20), a.AccountId) + '/' AS varchar(max)) AS HierarchyPath
    FROM dbo.ChartOfAccounts AS a
    WHERE a.ParentAccountId IS NULL

    UNION ALL

    SELECT
        child.AccountId,
        child.AccountNumber,
        child.AccountName,
        child.ParentAccountId,
        child.IsPostingAccount,
        child.IsActive,
        parent.HierarchyLevel + 1,
        CAST(parent.HierarchyPath + CONVERT(varchar(20), child.AccountId) + '/' AS varchar(max))
    FROM dbo.ChartOfAccounts AS child
    INNER JOIN AccountTree AS parent ON parent.AccountId = child.ParentAccountId
)
SELECT AccountId, AccountNumber, AccountName, ParentAccountId,
       IsPostingAccount, IsActive, HierarchyLevel, HierarchyPath
FROM AccountTree;
GO
