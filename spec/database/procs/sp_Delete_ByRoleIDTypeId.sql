create PROCEDURE [dbo].[sp_Delete_ByRoleIDTypeId]
	-- Add the parameters for the stored procedure here
	  @RoleId  INT ,
	  @TypeId  INT 


AS
BEGIN
	
	DELETE FROM dbo.tblMenuRole WHERE RoleId=@RoleId 
END
