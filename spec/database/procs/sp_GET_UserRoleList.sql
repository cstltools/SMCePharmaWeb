-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_UserRoleList]
	
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   

   DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'SELECT UR.UserRoleID, rt.RoleType, UR.RoleName, UR.IsActive, CONVERT(NVARCHAR(50),UR.ActiveInActiveDate,106) AS ActiveInActiveDate,
  CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus  
  FROM tbl_UserRoleInfo AS UR
  LEFT JOIN (SELECT DISTINCT UserRoleID,COUNT(UserRoleID) NoOf FROM tblUser WHERE UserRoleID IS NOT NULL GROUP BY UserRoleID) AS C ON UR.UserRoleID = C.UserRoleID

  left join tblRoleType rt on ur.RoleTypeId=rt.RoleTypeId

  WHERE UR.UserRoleID IS NOT NULL ' + @Parameter


   --SELECT GP.GroupCode + ':'+ GP.GroupName AS GroupName FROM tbl_Group AS GP
   --SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder AS INV GROUP BY ASMId
   

   EXEC(@Query)

 
END
