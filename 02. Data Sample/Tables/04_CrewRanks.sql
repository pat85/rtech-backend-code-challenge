/*
    Seed: CrewRanks
    20 common merchant-vessel ranks, ordered for display.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

INSERT INTO dbo.CrewRanks (RankName, RankDescription, DisplayOrder, IsActive)
SELECT v.RankName, v.RankDescription, v.DisplayOrder, 1
FROM (VALUES
(N'Master', N'Commanding officer of the vessel', 1),
(N'Chief Officer', N'Senior deck department officer', 2),
(N'Second Officer', N'Navigation officer', 3),
(N'Third Officer', N'Junior navigation officer', 4),
(N'Deck Cadet', N'Trainee deck officer', 5),
(N'Chief Engineer', N'Head of engine department', 6),
(N'Second Engineer', N'Senior assistant engineer', 7),
(N'Third Engineer', N'Assistant engineer', 8),
(N'Fourth Engineer', N'Junior engineer', 9),
(N'Engine Cadet', N'Trainee engine officer', 10),
(N'Electro-Technical Officer', N'Electrical and electronic systems', 11),
(N'Bosun', N'Deck crew supervisor', 12),
(N'Able Seafarer Deck', N'Qualified deck rating', 13),
(N'Ordinary Seafarer', N'Entry-level deck rating', 14),
(N'Chief Cook', N'Head of catering', 15),
(N'Cook', N'Catering crew', 16),
(N'Chief Steward', N'Head of hotel services', 17),
(N'Motorman', N'Engine room rating', 18),
(N'Oiler', N'Engine room rating', 19),
(N'Wiper', N'Entry-level engine room rating', 20)
) AS v(RankName, RankDescription, DisplayOrder)
WHERE NOT EXISTS (SELECT 1 FROM dbo.CrewRanks r WHERE r.RankName = v.RankName);

COMMIT TRANSACTION;
GO
