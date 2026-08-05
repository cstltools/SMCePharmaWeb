-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_UserList]
	
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   

   DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'SELECT  emp.EmpName,uRR.RoleName, uType.UserType, UR.UserStatus, CONVERT(NVARCHAR(50),UR.ActiveInActiveDate,106) AS ActiveInActiveDate,*   
  FROM tblUser AS UR with (nolock)
   

  left join tbl_UserRoleInfo uRR  with (nolock) on uRR.UserRoleID=UR.UserRoleID
  left join tblUserType uType  with (nolock) on uType.UserTypeId=UR.UserTypeId


     left join tblEmpGeneralInfo emp  with (nolock) on UR.EmpInfoId=emp.EmpInfoId


  WHERE UR.UserId IS NOT NULL   and UR.UserId not in (1)  ' + @Parameter


   --SELECT GP.GroupCode + ':'+ GP.GroupName AS GroupName FROM tbl_Group AS GP
   --SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder AS INV GROUP BY ASMId
   

   EXEC(@Query)

 
END
