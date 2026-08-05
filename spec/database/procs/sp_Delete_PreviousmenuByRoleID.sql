Create PROCEDURE [dbo].[sp_Delete_PreviousmenuByRoleID]
	-- Add the parameters for the stored procedure here
	  @id  INT 

AS
BEGIN
	
	DELETE FROM dbo.tblMenuRole WHERE RoleId=@id
END
