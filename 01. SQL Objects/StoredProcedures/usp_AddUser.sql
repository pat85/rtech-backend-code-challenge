/* Object: dbo.usp_AddUser */
CREATE OR ALTER PROCEDURE dbo.usp_AddUser
    @Username VARCHAR(100), @FullName NVARCHAR(150), @Role VARCHAR(50), @Email VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @Username = NULLIF(LTRIM(RTRIM(@Username)), '');
    SET @FullName = NULLIF(LTRIM(RTRIM(@FullName)), N'');
    SET @Role = NULLIF(LTRIM(RTRIM(@Role)), '');
    IF @Username IS NULL OR @FullName IS NULL OR @Role IS NULL
        THROW 50101, 'Username, FullName and Role are required.', 1;
    IF EXISTS (SELECT 1 FROM dbo.AppUsers WHERE Username = @Username)
        THROW 50102, 'Username already exists.', 1;
    INSERT dbo.AppUsers(Username, FullName, Email, [Role])
    VALUES (@Username, @FullName, @Email, @Role);
    SELECT UserId, Username, FullName, Email, [Role], IsActive, CreatedAt
    FROM dbo.AppUsers WHERE UserId = CONVERT(int, SCOPE_IDENTITY());
END;
GO
