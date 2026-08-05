CREATE PROCEDURE [dbo].[sp_Get_Group_List]
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)
AS
BEGIN
			

  DECLARE @Query NVARCHAR(MAX)

SET @Query = 'SELECT   CASE WHEN G.IsActive=1  THEN G.GroupName+'' : ''+G.GroupCode ELSE  G.GroupName+''(Inactive)''  END GroupName  , G.IsActive,* FROM tblNationalTargetSetup NTG
LEFT JOIN tbl_Group G ON NTG.GroupId = G.GroupId 
Where NTG.NatargetSpId IS NOT NULL ' + @Parameter

 EXEC(@Query)

END



