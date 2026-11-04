/* Object: dbo.vw_CrewServiceStatus
   Status is evaluated against the current SQL Server date. Services in the 1-30 day
   post-contract grace interval are intentionally not classified as Onboard or Relief Due. */
CREATE OR ALTER VIEW dbo.vw_CrewServiceStatus
AS
SELECT
    cs.CrewServiceId,
    cs.CrewMemberId,
    cs.ShipId,
    cs.RankId,
    cs.SignOnDate,
    cs.SignOffDate,
    cs.EndOfContractDate,
    CASE
        WHEN cs.SignOffDate IS NOT NULL THEN N'Signed Off'
        WHEN cs.SignOnDate > CONVERT(date, GETDATE()) THEN N'Planned to Join'
        WHEN cs.SignOnDate <= CONVERT(date, GETDATE())
             AND cs.EndOfContractDate >= CONVERT(date, GETDATE()) THEN N'Onboard'
        WHEN cs.SignOnDate <= CONVERT(date, GETDATE())
             AND DATEADD(day, 30, cs.EndOfContractDate) < CONVERT(date, GETDATE()) THEN N'Relief Due'
        ELSE N'Contract Grace Period'
    END AS ServiceStatus
FROM dbo.CrewServices AS cs;
GO
