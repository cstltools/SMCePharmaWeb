
CREATE PROCEDURE [dbo].[sp_da_CheckUserForceLogout]
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        [UserId],
        [IsForceLogout]
    FROM 
        [dbo].[tblUser]
    WHERE 
        [UserId] = @UserId
END
