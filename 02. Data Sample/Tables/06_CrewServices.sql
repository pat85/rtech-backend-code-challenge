/*
    Seed: CrewServices
    100 current assignments (20 per ship) plus 10 completed historical contracts.

    Status coverage as of 2026-10-31:
      - 60 Onboard (12 per ship)
      - 15 Relief Due (3 per ship; contract ended > 30 days ago)
      - 15 Signed Off (3 per ship)
      - 10 Planned to Join (2 per ship)
    The history rows do not overlap the current service periods for the same rank.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

INSERT INTO dbo.CrewServices
    (CrewMemberId, ShipId, RankId, SignOnDate, SignOffDate, EndOfContractDate)
SELECT
    v.CrewMemberId,
    s.ShipId,
    r.RankId,
    v.SignOnDate,
    v.SignOffDate,
    v.EndOfContractDate
FROM (VALUES
('CREW001', 'SHIP01', N'Master', '2026-01-15', NULL, '2027-01-15'),
('CREW002', 'SHIP01', N'Chief Officer', '2026-02-01', NULL, '2027-02-01'),
('CREW003', 'SHIP01', N'Second Officer', '2026-03-10', NULL, '2027-03-10'),
('CREW004', 'SHIP01', N'Third Officer', '2026-04-05', NULL, '2027-04-05'),
('CREW005', 'SHIP01', N'Deck Cadet', '2026-05-12', NULL, '2027-05-12'),
('CREW006', 'SHIP01', N'Chief Engineer', '2026-06-01', NULL, '2027-06-01'),
('CREW007', 'SHIP01', N'Second Engineer', '2026-06-18', NULL, '2027-06-18'),
('CREW008', 'SHIP01', N'Third Engineer', '2026-07-03', NULL, '2027-07-03'),
('CREW009', 'SHIP01', N'Fourth Engineer', '2026-07-20', NULL, '2027-07-20'),
('CREW010', 'SHIP01', N'Engine Cadet', '2026-08-01', NULL, '2027-08-01'),
('CREW011', 'SHIP01', N'Electro-Technical Officer', '2026-08-15', NULL, '2027-08-15'),
('CREW012', 'SHIP01', N'Bosun', '2026-09-01', NULL, '2027-09-01'),
('CREW013', 'SHIP01', N'Able Seafarer Deck', '2025-12-01', NULL, '2026-08-15'),
('CREW014', 'SHIP01', N'Ordinary Seafarer', '2025-12-01', NULL, '2026-08-25'),
('CREW015', 'SHIP01', N'Chief Cook', '2025-12-01', NULL, '2026-09-01'),
('CREW016', 'SHIP01', N'Cook', '2026-01-10', '2026-06-20', '2026-07-10'),
('CREW017', 'SHIP01', N'Chief Steward', '2026-02-10', '2026-07-20', '2026-08-10'),
('CREW018', 'SHIP01', N'Motorman', '2026-03-10', '2026-08-20', '2026-09-10'),
('CREW019', 'SHIP01', N'Oiler', '2026-11-15', NULL, '2027-05-15'),
('CREW020', 'SHIP01', N'Wiper', '2026-12-01', NULL, '2027-06-01'),
('CREW001', 'SHIP01', N'Master', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW002', 'SHIP01', N'Chief Officer', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW021', 'SHIP02', N'Master', '2026-01-15', NULL, '2027-01-15'),
('CREW022', 'SHIP02', N'Chief Officer', '2026-02-01', NULL, '2027-02-01'),
('CREW023', 'SHIP02', N'Second Officer', '2026-03-10', NULL, '2027-03-10'),
('CREW024', 'SHIP02', N'Third Officer', '2026-04-05', NULL, '2027-04-05'),
('CREW025', 'SHIP02', N'Deck Cadet', '2026-05-12', NULL, '2027-05-12'),
('CREW026', 'SHIP02', N'Chief Engineer', '2026-06-01', NULL, '2027-06-01'),
('CREW027', 'SHIP02', N'Second Engineer', '2026-06-18', NULL, '2027-06-18'),
('CREW028', 'SHIP02', N'Third Engineer', '2026-07-03', NULL, '2027-07-03'),
('CREW029', 'SHIP02', N'Fourth Engineer', '2026-07-20', NULL, '2027-07-20'),
('CREW030', 'SHIP02', N'Engine Cadet', '2026-08-01', NULL, '2027-08-01'),
('CREW031', 'SHIP02', N'Electro-Technical Officer', '2026-08-15', NULL, '2027-08-15'),
('CREW032', 'SHIP02', N'Bosun', '2026-09-01', NULL, '2027-09-01'),
('CREW033', 'SHIP02', N'Able Seafarer Deck', '2025-12-01', NULL, '2026-08-15'),
('CREW034', 'SHIP02', N'Ordinary Seafarer', '2025-12-01', NULL, '2026-08-25'),
('CREW035', 'SHIP02', N'Chief Cook', '2025-12-01', NULL, '2026-09-01'),
('CREW036', 'SHIP02', N'Cook', '2026-01-10', '2026-06-20', '2026-07-10'),
('CREW037', 'SHIP02', N'Chief Steward', '2026-02-10', '2026-07-20', '2026-08-10'),
('CREW038', 'SHIP02', N'Motorman', '2026-03-10', '2026-08-20', '2026-09-10'),
('CREW039', 'SHIP02', N'Oiler', '2026-11-15', NULL, '2027-05-15'),
('CREW040', 'SHIP02', N'Wiper', '2026-12-01', NULL, '2027-06-01'),
('CREW021', 'SHIP02', N'Master', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW022', 'SHIP02', N'Chief Officer', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW041', 'SHIP03', N'Master', '2026-01-15', NULL, '2027-01-15'),
('CREW042', 'SHIP03', N'Chief Officer', '2026-02-01', NULL, '2027-02-01'),
('CREW043', 'SHIP03', N'Second Officer', '2026-03-10', NULL, '2027-03-10'),
('CREW044', 'SHIP03', N'Third Officer', '2026-04-05', NULL, '2027-04-05'),
('CREW045', 'SHIP03', N'Deck Cadet', '2026-05-12', NULL, '2027-05-12'),
('CREW046', 'SHIP03', N'Chief Engineer', '2026-06-01', NULL, '2027-06-01'),
('CREW047', 'SHIP03', N'Second Engineer', '2026-06-18', NULL, '2027-06-18'),
('CREW048', 'SHIP03', N'Third Engineer', '2026-07-03', NULL, '2027-07-03'),
('CREW049', 'SHIP03', N'Fourth Engineer', '2026-07-20', NULL, '2027-07-20'),
('CREW050', 'SHIP03', N'Engine Cadet', '2026-08-01', NULL, '2027-08-01'),
('CREW051', 'SHIP03', N'Electro-Technical Officer', '2026-08-15', NULL, '2027-08-15'),
('CREW052', 'SHIP03', N'Bosun', '2026-09-01', NULL, '2027-09-01'),
('CREW053', 'SHIP03', N'Able Seafarer Deck', '2025-12-01', NULL, '2026-08-15'),
('CREW054', 'SHIP03', N'Ordinary Seafarer', '2025-12-01', NULL, '2026-08-25'),
('CREW055', 'SHIP03', N'Chief Cook', '2025-12-01', NULL, '2026-09-01'),
('CREW056', 'SHIP03', N'Cook', '2026-01-10', '2026-06-20', '2026-07-10'),
('CREW057', 'SHIP03', N'Chief Steward', '2026-02-10', '2026-07-20', '2026-08-10'),
('CREW058', 'SHIP03', N'Motorman', '2026-03-10', '2026-08-20', '2026-09-10'),
('CREW059', 'SHIP03', N'Oiler', '2026-11-15', NULL, '2027-05-15'),
('CREW060', 'SHIP03', N'Wiper', '2026-12-01', NULL, '2027-06-01'),
('CREW041', 'SHIP03', N'Master', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW042', 'SHIP03', N'Chief Officer', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW061', 'SHIP04', N'Master', '2026-01-15', NULL, '2027-01-15'),
('CREW062', 'SHIP04', N'Chief Officer', '2026-02-01', NULL, '2027-02-01'),
('CREW063', 'SHIP04', N'Second Officer', '2026-03-10', NULL, '2027-03-10'),
('CREW064', 'SHIP04', N'Third Officer', '2026-04-05', NULL, '2027-04-05'),
('CREW065', 'SHIP04', N'Deck Cadet', '2026-05-12', NULL, '2027-05-12'),
('CREW066', 'SHIP04', N'Chief Engineer', '2026-06-01', NULL, '2027-06-01'),
('CREW067', 'SHIP04', N'Second Engineer', '2026-06-18', NULL, '2027-06-18'),
('CREW068', 'SHIP04', N'Third Engineer', '2026-07-03', NULL, '2027-07-03'),
('CREW069', 'SHIP04', N'Fourth Engineer', '2026-07-20', NULL, '2027-07-20'),
('CREW070', 'SHIP04', N'Engine Cadet', '2026-08-01', NULL, '2027-08-01'),
('CREW071', 'SHIP04', N'Electro-Technical Officer', '2026-08-15', NULL, '2027-08-15'),
('CREW072', 'SHIP04', N'Bosun', '2026-09-01', NULL, '2027-09-01'),
('CREW073', 'SHIP04', N'Able Seafarer Deck', '2025-12-01', NULL, '2026-08-15'),
('CREW074', 'SHIP04', N'Ordinary Seafarer', '2025-12-01', NULL, '2026-08-25'),
('CREW075', 'SHIP04', N'Chief Cook', '2025-12-01', NULL, '2026-09-01'),
('CREW076', 'SHIP04', N'Cook', '2026-01-10', '2026-06-20', '2026-07-10'),
('CREW077', 'SHIP04', N'Chief Steward', '2026-02-10', '2026-07-20', '2026-08-10'),
('CREW078', 'SHIP04', N'Motorman', '2026-03-10', '2026-08-20', '2026-09-10'),
('CREW079', 'SHIP04', N'Oiler', '2026-11-15', NULL, '2027-05-15'),
('CREW080', 'SHIP04', N'Wiper', '2026-12-01', NULL, '2027-06-01'),
('CREW061', 'SHIP04', N'Master', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW062', 'SHIP04', N'Chief Officer', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW081', 'SHIP05', N'Master', '2026-01-15', NULL, '2027-01-15'),
('CREW082', 'SHIP05', N'Chief Officer', '2026-02-01', NULL, '2027-02-01'),
('CREW083', 'SHIP05', N'Second Officer', '2026-03-10', NULL, '2027-03-10'),
('CREW084', 'SHIP05', N'Third Officer', '2026-04-05', NULL, '2027-04-05'),
('CREW085', 'SHIP05', N'Deck Cadet', '2026-05-12', NULL, '2027-05-12'),
('CREW086', 'SHIP05', N'Chief Engineer', '2026-06-01', NULL, '2027-06-01'),
('CREW087', 'SHIP05', N'Second Engineer', '2026-06-18', NULL, '2027-06-18'),
('CREW088', 'SHIP05', N'Third Engineer', '2026-07-03', NULL, '2027-07-03'),
('CREW089', 'SHIP05', N'Fourth Engineer', '2026-07-20', NULL, '2027-07-20'),
('CREW090', 'SHIP05', N'Engine Cadet', '2026-08-01', NULL, '2027-08-01'),
('CREW091', 'SHIP05', N'Electro-Technical Officer', '2026-08-15', NULL, '2027-08-15'),
('CREW092', 'SHIP05', N'Bosun', '2026-09-01', NULL, '2027-09-01'),
('CREW093', 'SHIP05', N'Able Seafarer Deck', '2025-12-01', NULL, '2026-08-15'),
('CREW094', 'SHIP05', N'Ordinary Seafarer', '2025-12-01', NULL, '2026-08-25'),
('CREW095', 'SHIP05', N'Chief Cook', '2025-12-01', NULL, '2026-09-01'),
('CREW096', 'SHIP05', N'Cook', '2026-01-10', '2026-06-20', '2026-07-10'),
('CREW097', 'SHIP05', N'Chief Steward', '2026-02-10', '2026-07-20', '2026-08-10'),
('CREW098', 'SHIP05', N'Motorman', '2026-03-10', '2026-08-20', '2026-09-10'),
('CREW099', 'SHIP05', N'Oiler', '2026-11-15', NULL, '2027-05-15'),
('CREW100', 'SHIP05', N'Wiper', '2026-12-01', NULL, '2027-06-01'),
('CREW081', 'SHIP05', N'Master', '2024-01-10', '2024-07-10', '2024-07-10'),
('CREW082', 'SHIP05', N'Chief Officer', '2024-01-10', '2024-07-10', '2024-07-10')
) AS v(CrewMemberId, ShipCode, RankName, SignOnDate, SignOffDate, EndOfContractDate)
JOIN dbo.Ships s ON s.ShipCode = v.ShipCode
JOIN dbo.CrewRanks r ON r.RankName = v.RankName
JOIN dbo.CrewMembers c ON c.CrewMemberId = v.CrewMemberId
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.CrewServices cs
    WHERE cs.CrewMemberId = v.CrewMemberId
      AND cs.ShipId = s.ShipId
      AND cs.RankId = r.RankId
      AND cs.SignOnDate = v.SignOnDate
);

COMMIT TRANSACTION;
GO
