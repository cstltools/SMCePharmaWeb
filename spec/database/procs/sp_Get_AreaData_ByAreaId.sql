-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_AreaData_ByAreaId]  -- [sp_Get_ZoneData_ByZoneId] 5
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN

	 Select 
	 STUFF(( SELECT  ',' + CAST(DistrictId AS NVARCHAR(50))
                FROM    dbo.tbl_AreaDistrictRelation
				WHERE AreaId = @id
              FOR
                XML PATH('')
              ), 1, 1, '') AS DistrictId , tbl_Group.GroupId,* 
	 FROM dbo.tblArea 
	 LEFT JOIN tblRegion On tblRegion.RegionId = tblArea.RegionId
	 LEFT JOIN tbl_Group On tbl_Group.GroupId = tblRegion.GroupId
	 WHERE AreaId = @id


END

