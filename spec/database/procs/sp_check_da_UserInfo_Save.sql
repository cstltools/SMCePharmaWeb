CREATE PROCEDURE [dbo].[sp_check_da_UserInfo_Save]
      @UserId INT,
      @LoginName NVARCHAR(MAX) = NULL,
      @EmpInfoId INT = NULL,
      @DaInfoId INT = NULL
AS
BEGIN
    SELECT * FROM dbo.tblUser WHERE LoginName=@LoginName
    UNION ALL
    SELECT * FROM dbo.tblUser WHERE EmpInfoId=@EmpInfoId AND EmpInfoId IS NOT NULL AND UserTypeId NOT IN (6, 7)
    UNION ALL
    SELECT * FROM dbo.tblUser WHERE DaInfoId=@DaInfoId AND DaInfoId IS NOT NULL AND UserTypeId IN (6, 7)
END
