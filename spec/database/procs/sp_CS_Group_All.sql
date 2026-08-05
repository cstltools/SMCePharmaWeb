CREATE PROCEDURE [dbo].[sp_CS_Group_All]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT GroupId,GroupCode+' : '+  CASE WHEN IsActive=1 THEN   GroupName  ELSE   GroupName+' (Inactive)' END  GroupName  FROM dbo.tbl_Group  with(nolock)
END
