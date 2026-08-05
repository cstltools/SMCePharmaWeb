
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TourPurposeOtherSetupId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

        select RoleName RoleId, 
    d.TerritoryId, 
    d.AreaId, 
    d.RegionId, 
    d.GroupId, 
  d.TourTypeId   StationTypeId,  RoleName AS Role, 
 tr.TerritoryCode+ ' : ' +   tr.TerritoryName AS Territory, 
  a.AreaCode + ' : ' +  a.AreaName AS Area, 
 rg.RegionCode + ' : ' +   rg.RegionName AS Region,   gr.GroupCode + ' : ' +   gr.GroupName AS [Group], 
    st.StationTypeName AS StationType, * from tblTourPurposeOtherSetup m
		inner join tblTourPurposeOtherSetupDtl d on m.TourPurposeOtherSetupId=d.TourPurposeOtherSetupId

		left join tblTerritory tr on  d.TerritoryId=tr.TerritoryId
		left join tblArea a on  d.AreaId=a.AreaId
		left join tblRegion rg on  d.RegionId=rg.RegionId
		left join tbl_Group gr on  d.GroupId=gr.GroupId
		left join tblStationType st on  d.TourTypeId=st.StationTypeId

		 


  
				WHERE m.TourPurposeId = @id

				order by RoleName asc






    END


