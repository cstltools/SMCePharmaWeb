
CREATE PROCEDURE [dbo].[sp_GetLatestAppVersion]
    @AppName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 
        [Id],
        [AppName],
        [LatestVersionCode],
        [LatestVersionName],
        [MinimumRequiredVersionCode],
        [UpdateUrl],
        [ReleaseNotes],
        [IsActive],
        [CreatedDate],
        [UpdatedDate]
    FROM 
        [dbo].[tblAppVersionControl]
    WHERE 
        [AppName] = @AppName 
        AND [IsActive] = 1
    ORDER BY 
        [Id] DESC
END
