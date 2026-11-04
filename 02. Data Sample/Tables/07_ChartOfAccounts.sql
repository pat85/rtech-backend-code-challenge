/*
    Seed: ChartOfAccounts
    Five top-level parent accounts, each with five direct children.
    Operating Expenses also contains a second hierarchy level under 7100000,
    including the challenge's sample accounts 7120000 and 7135000.
    Only posting/detail accounts accept budgets and actual transactions.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- Level 1: top-level summary accounts.
INSERT INTO dbo.ChartOfAccounts
    (AccountNumber, AccountName, ParentAccountId, IsPostingAccount, IsActive)
SELECT v.AccountNumber, v.AccountName, NULL, 0, 1
FROM (VALUES
('7000000', N'OPERATING EXPENSES'),
('8000000', N'CREW COSTS'),
('9000000', N'PORT AND VOYAGE EXPENSES'),
('6000000', N'TECHNICAL AND VESSEL MAINTENANCE'),
('5000000', N'GENERAL AND ADMINISTRATIVE')
) AS v(AccountNumber, AccountName)
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.ChartOfAccounts a WHERE a.AccountNumber = v.AccountNumber
);

-- Level 2: five children for each top-level account.
INSERT INTO dbo.ChartOfAccounts
    (AccountNumber, AccountName, ParentAccountId, IsPostingAccount, IsActive)
SELECT v.AccountNumber, v.AccountName, p.AccountId, v.IsPostingAccount, 1
FROM (VALUES
('7100000', N'AWARD AND GRANT TO INDIVIDUALS', '7000000', 0),
('7200000', N'TRAVEL EXPENSES', '7000000', 1),
('7300000', N'VESSEL MAINTENANCE', '7000000', 1),
('7400000', N'SHIP STORES AND SUPPLIES', '7000000', 1),
('7500000', N'COMMUNICATIONS', '7000000', 1),
('8100000', N'CREW WAGES', '8000000', 1),
('8200000', N'CREW OVERTIME', '8000000', 1),
('8300000', N'CREW VICTUALLING', '8000000', 1),
('8400000', N'CREW TRAINING', '8000000', 1),
('8500000', N'CREW MEDICAL EXPENSES', '8000000', 1),
('9100000', N'PORT DUES AND CHARGES', '9000000', 1),
('9200000', N'PILOTAGE AND TOWAGE', '9000000', 1),
('9300000', N'BUNKERS AND LUBRICANTS', '9000000', 1),
('9400000', N'CANAL AND PASSAGE FEES', '9000000', 1),
('9500000', N'AGENCY FEES', '9000000', 1),
('6100000', N'ENGINE REPAIRS', '6000000', 1),
('6200000', N'HULL AND DECK REPAIRS', '6000000', 1),
('6300000', N'SAFETY EQUIPMENT', '6000000', 1),
('6400000', N'DRY DOCKING', '6000000', 1),
('6500000', N'SPARE PARTS', '6000000', 1),
('5100000', N'OFFICE AND ADMINISTRATION', '5000000', 1),
('5200000', N'PROFESSIONAL SERVICES', '5000000', 1),
('5300000', N'INSURANCE', '5000000', 1),
('5400000', N'IT AND SOFTWARE', '5000000', 1),
('5500000', N'BANK AND FINANCE CHARGES', '5000000', 1)
) AS v(AccountNumber, AccountName, ParentAccountNumber, IsPostingAccount)
JOIN dbo.ChartOfAccounts p ON p.AccountNumber = v.ParentAccountNumber
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.ChartOfAccounts a WHERE a.AccountNumber = v.AccountNumber
);

-- Level 3: detail accounts below Award and Grant to Individuals.
INSERT INTO dbo.ChartOfAccounts
    (AccountNumber, AccountName, ParentAccountId, IsPostingAccount, IsActive)
SELECT v.AccountNumber, v.AccountName, p.AccountId, v.IsPostingAccount, 1
FROM (VALUES
('7120000', N'AWARDS', '7100000', 1),
('7135000', N'SCHOLARSHIPS', '7100000', 1),
('7140000', N'TRAINING GRANTS', '7100000', 1),
('7150000', N'CREW WELFARE GRANTS', '7100000', 1),
('7160000', N'OTHER INDIVIDUAL GRANTS', '7100000', 1)
) AS v(AccountNumber, AccountName, ParentAccountNumber, IsPostingAccount)
JOIN dbo.ChartOfAccounts p ON p.AccountNumber = v.ParentAccountNumber
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.ChartOfAccounts a WHERE a.AccountNumber = v.AccountNumber
);

COMMIT TRANSACTION;
GO
