/* Object: dbo.usp_GetCrewList
   Returns only currently Onboard or Relief Due crew, excluding signed-off services.
   Search is applied to all requested fields except Status. Partial dates support dd MMM (e.g. 05 Apr).
*/
CREATE OR ALTER PROCEDURE dbo.usp_GetCrewList
    @ShipCode       VARCHAR(20),
    @PageNumber     INT = 1,
    @PageSize       INT = 20,
    @SortColumn     SYSNAME = N'RankName',
    @SortDirection  VARCHAR(4) = 'ASC',
    @SearchTerm     NVARCHAR(100) = NULL,
    @AsOfDate       DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @AsOfDate = COALESCE(@AsOfDate, CONVERT(date, GETDATE()));
    SET @SearchTerm = NULLIF(LTRIM(RTRIM(@SearchTerm)), N'');
    SET @SortDirection = UPPER(@SortDirection);

    IF @PageNumber < 1 OR @PageSize < 1 OR @PageSize > 500
        THROW 50001, 'PageNumber must be >= 1 and PageSize must be between 1 and 500.', 1;
    IF @SortDirection NOT IN ('ASC', 'DESC')
        THROW 50002, 'SortDirection must be ASC or DESC.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.Ships WHERE ShipCode = @ShipCode AND IsActive = 1)
        THROW 50003, 'Ship was not found or is inactive.', 1;

    DECLARE @AllowedSort TABLE (SortColumn SYSNAME PRIMARY KEY);
    INSERT INTO @AllowedSort(SortColumn)
    VALUES (N'RankName'), (N'CrewMemberId'), (N'FirstName'), (N'LastName'),
           (N'Age'), (N'Nationality'), (N'SignOnDate'), (N'Status');

    IF NOT EXISTS (SELECT 1 FROM @AllowedSort WHERE SortColumn = @SortColumn)
        THROW 50004, 'Unsupported SortColumn.', 1;

    DECLARE @Offset BIGINT = (CONVERT(BIGINT, @PageNumber) - 1) * @PageSize;
    DECLARE @sql NVARCHAR(MAX) = N'
    ;WITH CrewRows AS
    (
        SELECT
            r.RankName,
            cm.CrewMemberId,
            cm.FirstName,
            cm.LastName,
            DATEDIFF(year, cm.BirthDate, @pAsOfDate)
                - CASE WHEN DATEADD(year, DATEDIFF(year, cm.BirthDate, @pAsOfDate), cm.BirthDate) > @pAsOfDate THEN 1 ELSE 0 END AS Age,
            cm.Nationality,
            cs.SignOnDate,
            CASE WHEN DATEDIFF(day, cs.EndOfContractDate, @pAsOfDate) > 30
                 THEN N''Relief Due'' ELSE N''Onboard'' END AS [Status],
            cs.CrewServiceId
        FROM dbo.CrewServices AS cs
        INNER JOIN dbo.Ships AS s ON s.ShipId = cs.ShipId
        INNER JOIN dbo.CrewMembers AS cm ON cm.CrewMemberId = cs.CrewMemberId
        INNER JOIN dbo.CrewRanks AS r ON r.RankId = cs.RankId
        WHERE s.ShipCode = @pShipCode
          AND s.IsActive = 1
          AND cs.SignOffDate IS NULL
          AND cs.SignOnDate <= @pAsOfDate
          AND (cs.EndOfContractDate >= @pAsOfDate
               OR DATEDIFF(day, cs.EndOfContractDate, @pAsOfDate) > 30)
    ), Filtered AS
    (
        SELECT * FROM CrewRows
        WHERE @pSearch IS NULL
           OR RankName LIKE N''%'' + @pSearch + N''%''
           OR CrewMemberId LIKE N''%'' + @pSearch + N''%''
           OR FirstName LIKE N''%'' + @pSearch + N''%''
           OR LastName LIKE N''%'' + @pSearch + N''%''
           OR Nationality LIKE N''%'' + @pSearch + N''%''
           OR CONVERT(nvarchar(10), SignOnDate, 105) LIKE N''%'' + @pSearch + N''%''
           OR FORMAT(SignOnDate, ''dd MMM'', ''en-US'') LIKE N''%'' + @pSearch + N''%''
           OR CONVERT(nvarchar(10), SignOnDate, 23) LIKE N''%'' + @pSearch + N''%''
           OR CONVERT(nvarchar(10), Age) LIKE N''%'' + @pSearch + N''%''
    )
    SELECT RankName, CrewMemberId, FirstName, LastName, Age, Nationality,
           SignOnDate, [Status], COUNT_BIG(*) OVER() AS TotalCount
    FROM Filtered
    ORDER BY ' + QUOTENAME(@SortColumn) + N' ' + @SortDirection + N', CrewServiceId ASC
    OFFSET @pOffset ROWS FETCH NEXT @pPageSize ROWS ONLY;';

    EXEC sys.sp_executesql
        @sql,
        N'@pShipCode varchar(20), @pAsOfDate date, @pSearch nvarchar(100), @pOffset bigint, @pPageSize int',
        @pShipCode = @ShipCode,
        @pAsOfDate = @AsOfDate,
        @pSearch = @SearchTerm,
        @pOffset = @Offset,
        @pPageSize = @PageSize;
END;
GO
