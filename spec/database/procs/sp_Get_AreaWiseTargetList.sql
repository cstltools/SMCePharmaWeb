
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_AreaWiseTargetList]
	-- Add the parameters for the stored procedure here
	@Parameter nvarchar(max)=null
AS
BEGIN
   DECLARE @Query NVARCHAR(MAX)

SET @Query ='SELECT  CASE WHEN AR.IsActive=1  THEN ar.AreaCode +'' : ''+ AR.AreaName  ELSE  AR.AreaName+''(Inactive)''  END AreaName  , AR.IsActive,* FROM tblAreaWiseTargetSetup AWT
LEFT JOIN tbl_Group G ON AWT.GroupId = G.GroupId 
LEFT JOIN tblRegion A ON AWT.RegionId = A.RegionId
LEFT JOIN tblArea  AR ON AWT.AreaId = AR.AreaId
Where AWT.AreaWTSetupId IS NOT NULL'+@Parameter  

EXEC(@Query)
	
END



