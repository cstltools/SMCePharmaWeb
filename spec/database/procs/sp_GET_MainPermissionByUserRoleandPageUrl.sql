
CREATE PROCEDURE [dbo].[sp_GET_MainPermissionByUserRoleandPageUrl]
	-- Add the parameters for the stored procedure here
   @RoleId INT,
   @PageName nvarchar(max)


AS
    BEGIN
	---RoleId,tblMenuRole.[Add] AS RAdd,tblMenuRole.[View] AS RView,tblMenuRole.[Delete] AS RDelete,tblMenuRole.Edit AS REdit
	SELECT 
	RoleId, case  when tblMenuRole.[Add]=1 then 'true' else 'false' end AS RAdd, case  when tblMenuRole.Edit=1 then 'true' else 'false' end AS  REdit 
	,tblMenuRole.Permission FROM dbo.tblMenuRole 
	LEFT JOIN dbo.tblMainMenuNew M ON M.SL = tblMenuRole.SL
	LEFT JOIN dbo.tblMainMenuNew P ON M.ParantId=P.SL
	WHERE RoleId=@RoleId  AND M.URL=@PageName

			
    END

	

