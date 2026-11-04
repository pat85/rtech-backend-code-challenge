# RTech Backend Challenge – Seed Data

This folder contains deterministic, re-runnable SQL Server seed scripts for the DDL previously generated for the challenge.

## Prerequisites

1. Create the database.
2. Execute the DDL scripts first, in dependency order, so all nine tables and their constraints exist.
3. Select the target database in SQL Server Management Studio (SSMS).
4. Execute the seed scripts in the order below.

## Execution order

| Order | File | Contents |
|---:|---|---|
| 1 | `Tables/01_Ships.sql` | Five ships with active/inactive status and fiscal calendars |
| 2 | `Tables/02_AppUsers.sql` | Five demo users |
| 3 | `Tables/03_UserShips.sql` | User-to-ship assignments |
| 4 | `Tables/04_CrewRanks.sql` | Twenty maritime rank types |
| 5 | `Tables/05_CrewMembers.sql` | 100 crew members |
| 6 | `Tables/06_CrewServices.sql` | 100 current assignments plus 10 completed historical services |
| 7 | `Tables/07_ChartOfAccounts.sql` | Five COA roots, 25 direct children and five additional detail accounts |
| 8 | `Tables/08_AccountBudgets.sql` | Monthly budgets for three ships, ten posting accounts, 2024 and 2025 |
| 9 | `Tables/09_AccountTransactions.sql` | Actual transactions for three ships, ten posting accounts, all of 2024 and Jan-Jun 2025 |

You can execute `Run/Run_All.sql` from the package root in SSMS after enabling **Query > SQLCMD Mode**. Otherwise, run the nine files individually in the order above.

## Seed-data coverage

### Ships and users

- `SHIP01` – Flying Dutchman: active, fiscal year January–December (`0112`).
- `SHIP02` – Thousand Sunny: active, fiscal year April–March (`0403`).
- `SHIP03` – Black Pearl: active, fiscal year April–March (`0403`).
- `SHIP04` – Queen Anne's Revenge: inactive, fiscal year October–September (`1009`).
- `SHIP05` – Nautilus: active, fiscal year January–December (`0112`).

Three ships (`SHIP01`–`SHIP03`) have budget and actual data, as required. The inactive ship is intentionally not given financial records.

### Crew

There are 20 current crew assignments per ship (100 total), with 20 distinct ranks. As of **2026-10-31**, the current assignment rows deliberately cover:

- 60 Onboard (12 per ship).
- 15 Relief Due (3 per ship; contract ended more than 30 days ago).
- 15 Signed Off (3 per ship).
- 10 Planned to Join (2 per ship).

Ten additional rows are completed historical contracts for the first two crew members on each ship. These historical assignments end in 2024 and do not overlap the current assignment for the same rank.

The date values are intentionally anchored around 2026-10-31 so the status examples are reproducible when the challenge's crew procedure is run with that `@AsOfDate`. If the procedure uses the current server date, the status distribution will naturally change over time.

### Chart of Accounts

The COA contains five top-level summary accounts. Each has five direct child accounts. The Operating Expenses branch also has a further nested group (`7100000`) and five leaf/detail accounts, including the challenge sample accounts:

- `7000000` – Operating Expenses
  - `7100000` – Award and Grant to Individuals
    - `7120000` – Awards
    - `7135000` – Scholarships
    - `7140000` – Training Grants
    - `7150000` – Crew Welfare Grants
    - `7160000` – Other Individual Grants

All seeded budgets and actuals are posted only to accounts marked `IsPostingAccount = 1`. Parent and group account values should be calculated by the reporting procedures.

### Budgets and actuals

- Budgets: 718 rows across three ships, ten posting accounts and 24 calendar months (Jan 2024–Dec 2025).
- Actual transactions: 674 rows across three ships, ten posting accounts, all 12 months of 2024 and Jan–Jun 2025.
- Selected periods contain multiple actual transaction rows to demonstrate aggregation.
- Explicit zero-value budget and transaction records are included.
- A small number of budget/actual cells are deliberately absent to demonstrate the difference between a missing value (`NULL` in a report) and an explicitly stored zero.
- `SHIP01` / account `7135000` / January 2025 has a budget of 1,000 and actual transactions of 300, 0 and 700, matching the arithmetic in the challenge's sample.

The challenge README contains an inconsistent example with two budget rows for the same ship, account and period (0 and 1,000). The proposed `AccountBudgets` schema has a unique constraint on `(ShipId, AccountId, AccountingPeriod)`, so this seed set stores one budget row of 1,000 for that example. An explicit zero budget is demonstrated in another period.

## Idempotency and safety

- The scripts use natural keys and `NOT EXISTS` checks; re-running them will not intentionally duplicate the seeded rows.
- They do not truncate or delete existing data.
- They do not reset identity values.
- Run against a dedicated development/test database, not production.
- Existing rows with the same natural key are left unchanged; these scripts are seeds, not synchronization or update scripts.

## Quick validation queries

Run these after seeding:

```sql
SELECT ShipCode, ShipName, IsActive, FiscalYearStartMonth, FiscalYearEndMonth
FROM dbo.Ships
ORDER BY ShipCode;

SELECT s.ShipCode, COUNT(*) AS CurrentServiceRows
FROM dbo.CrewServices cs
JOIN dbo.Ships s ON s.ShipId = cs.ShipId
WHERE cs.SignOnDate >= '2025-01-01'
GROUP BY s.ShipCode
ORDER BY s.ShipCode;

SELECT COUNT(*) AS CrewMembers FROM dbo.CrewMembers;
SELECT COUNT(*) AS CrewRanks FROM dbo.CrewRanks;
SELECT COUNT(*) AS COAAccounts FROM dbo.ChartOfAccounts;
SELECT COUNT(*) AS BudgetRows FROM dbo.AccountBudgets;
SELECT COUNT(*) AS TransactionRows FROM dbo.AccountTransactions;

SELECT s.ShipCode, a.AccountNumber,
       b.AccountingPeriod, b.BudgetValue
FROM dbo.AccountBudgets b
JOIN dbo.Ships s ON s.ShipId = b.ShipId
JOIN dbo.ChartOfAccounts a ON a.AccountId = b.AccountId
WHERE s.ShipCode = 'SHIP01'
  AND a.AccountNumber = '7135000'
  AND b.AccountingPeriod = '2025-01-01';

SELECT s.ShipCode, a.AccountNumber,
       t.AccountingPeriod, SUM(t.ActualValue) AS ActualValue
FROM dbo.AccountTransactions t
JOIN dbo.Ships s ON s.ShipId = t.ShipId
JOIN dbo.ChartOfAccounts a ON a.AccountId = t.AccountId
WHERE s.ShipCode = 'SHIP01'
  AND a.AccountNumber = '7135000'
  AND t.AccountingPeriod = '2025-01-01'
GROUP BY s.ShipCode, a.AccountNumber, t.AccountingPeriod;
```

Expected key counts for a clean database:
- Ships: 5
- AppUsers: 5
- UserShips: 16
- CrewRanks: 20
- CrewMembers: 100
- CrewServices: 110
- ChartOfAccounts: 35
- AccountBudgets: 718
- AccountTransactions: 674
