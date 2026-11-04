# RTech Backend Challenge — SQL Server Object Scripts

These scripts implement the proposed normalized schema for SQL Server / Azure SQL Database.
Each database object has its own `.sql` file.

## Contents

- `Tables/` — 9 tables: Ships, AppUsers, UserShips, CrewMembers, CrewRanks, CrewServices, ChartOfAccounts, AccountBudgets, AccountTransactions.
- `Views/` — crew service status and COA hierarchy views.
- `StoredProcedures/` — user/ship creation and listing, user-ship assignment, crew list, financial detail report, financial summary report.

## Execution order

Pre-requisite: Create the database first.

Run scripts in this order (from the project root):

1. `Tables/Ships.sql`
2. `Tables/AppUsers.sql`
3. `Tables/CrewMembers.sql`
4. `Tables/CrewRanks.sql`
5. `Tables/ChartOfAccounts.sql`
6. `Tables/UserShips.sql`
7. `Tables/CrewServices.sql`
8. `Tables/AccountBudgets.sql`
9. `Tables/AccountTransactions.sql`
10. `Views/vw_CrewServiceStatus.sql`
11. `Views/vw_ChartOfAccountsHierarchy.sql`
12. `StoredProcedures/usp_AddUser.sql`
13. `StoredProcedures/usp_GetUsers.sql`
14. `StoredProcedures/usp_AddShip.sql`
15. `StoredProcedures/usp_GetShips.sql`
16. `StoredProcedures/usp_AssignShipToUser.sql`
17. `StoredProcedures/usp_GetShipsByUser.sql`
18. `StoredProcedures/usp_GetCrewList.sql`
19. `StoredProcedures/usp_GetFinancialReportDetail.sql`
20. `StoredProcedures/usp_GetFinancialReportSummary.sql`

The current package contains 20 SQL object files (9 tables, 2 views and 9 stored procedures). Each file uses `GO` batch separators and can be run in SSMS or Azure Data Studio.

## Design notes and assumptions

- `Ships.FiscalYearStartMonth` and `FiscalYearEndMonth` represent the fiscal-year boundaries. YTD start is calculated from the start month; end month is retained for configuration/documentation and should be consistent with the start month (12 months inclusive).
- `AccountingPeriod` is a `DATE` set to the first day of its month. Procedures reject other dates.
- Budgets are unique per ship/account/period. The README's two January 2025 budget rows for the same ship/account (0 and 1000) conflict with this rule; load one approved budget row (or introduce a budget-version model if revisions are required).
- Actual transactions are appendable and may have multiple rows per ship/account/period. Zero values are permitted.
- Only posting (leaf/detail) accounts receive budgets and actual transactions. The procedures aggregate their values to all ancestors for detail reporting, and to top-level accounts for summary reporting.
- The crew-list procedure returns Onboard and Relief Due services only, and excludes signed-off services. A service becomes Relief Due only when the contract end date is more than 30 days before `@AsOfDate`. The 1–30 day grace interval is excluded from this operational list because the challenge only requests Onboard or Relief Due.
- `@AsOfDate` is optional on the crew procedure for deterministic testing; omitted means the SQL Server local date.
- Search supports partial text, ISO/European date representations, and `dd MMM` date fragments such as `05 Apr`. Status is intentionally not searchable.
- Sorting is limited to the specified allowlist and uses `QUOTENAME`; all search and filter values are parameterized.
- Reports preserve NULL when both monthly/YTD measures are absent; variance is NULL in that case. If one side exists, variance is calculated using zero for the missing side. Rows whose monthly and YTD budget/actual values are all zero or NULL are omitted, per the challenge notes.
- The scripts are object DDL, not sample-data scripts. Seed data should be delivered separately.

## Important follow-up validation

The DDL enforces referential integrity and date/value checks. It does not by itself prevent overlapping crew service periods for the same crew member or duplicate active rank assignments on a ship. Those are cross-row temporal business rules and should be validated transactionally in the crew assignment write procedures (with appropriate locking/transaction isolation).

The `vw_ChartOfAccountsHierarchy` view assumes the COA is an acyclic tree. Preventing longer cycles should be handled in the COA maintenance procedure/application validation.
