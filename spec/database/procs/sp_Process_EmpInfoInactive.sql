

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Process_EmpInfoInactive]
	-- Add the parameters for the stored procedure here
	 @Date     DATETIME 

AS
BEGIN

DECLARE @EmpInfoId INT 
SELECT EmpInfoId FROM dbo.tblEmpGeneralInfo WHERE CONVERT(DATE,JobLeftDate)=CONVERT(DATE,@Date)

DECLARE @RoleName NVARCHAR(max)
SELECT @RoleName=ur.RoleName FROM dbo.tblUser usr
LEFT JOIN dbo.tbl_UserRoleInfo ur ON usr.UserRoleID=ur.UserRoleID
WHERE  EmpInfoId=@EmpInfoId
 
UPDATE dbo.tblUser SET UserStatus='Inactive' WHERE EmpInfoId=@EmpInfoId
UPDATE dbo.tblEmpGeneralInfo SET EmployeeStatus='Inactive' WHERE EmpInfoId=@EmpInfoId


IF(@RoleName='MIO')
BEGIN
UPDATE dbo.tblMIOInfo SET IsActive=0 WHERE EmployeeId=@EmpInfoId
END


IF(@RoleName='MIO')
BEGIN
UPDATE dbo.tblMIOInfo SET IsActive=0 WHERE EmployeeId=@EmpInfoId
END


IF(@RoleName='AM')
BEGIN
UPDATE dbo.tblASMInfo SET IsActive=0 WHERE EmployeeId=@EmpInfoId
END


IF(@RoleName='NSM')
BEGIN
UPDATE dbo.tblASMInfo SET IsActive=0 WHERE EmployeeId=@EmpInfoId
end


END



