
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ZoneWiseTargetList]
	-- Add the parameters for the stored procedure here
	@Parameter nvarchar(max)=null
AS
BEGIN
   DECLARE @Query NVARCHAR(MAX)

SET @Query ='SELECT  CASE WHEN A.IsActive=1  THEN A.RegionName+'' : ''+A.RegionCode  ELSE  A.RegionName+''(Inactive)''  END RegionName  , A.IsActive,* FROM tblZoneWiseTargetSetup
 ZWT
LEFT JOIN tbl_Group G ON ZWT.GroupId = G.GroupId 
LEFT JOIN tblRegion A ON ZWT.RegionId =A.RegionId
Where ZWT.ZoneWTSetupId IS NOT NULL '+@Parameter  

 EXEC(@Query)
	
END




 


