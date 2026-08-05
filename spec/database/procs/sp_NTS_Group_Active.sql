CREATE PROCEDURE [dbo].[sp_NTS_Group_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT GroupId,GroupCode+' : '+ GroupName GroupName FROM dbo.tbl_Group  with(nolock)  WHERE IsActive=1
END


