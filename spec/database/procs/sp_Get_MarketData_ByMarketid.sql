-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_MarketData_ByMarketid]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN
	

        SELECT M.IsActive, FORMAT(m.acInAcDate,'dd MMMM, yyyy') AcOrInAcDate, uRole.DisplayName RoleType, stt.StationTypeName,  dtl.StationTypeId,dtl.UserRoleID RoleTypeId, sT.SubTerritoryId, T.TerritoryId, A.AreaId,
				R.RegionId,
				G.GroupId,  tha.ThanaId, dis.DistrictId,div.DivisionId,  M.*
		    
				
        FROM    dbo.tblMarket M
                LEFT JOIN dbo.tblSubTerritory sT ON sT.SubTerritoryId = M.SubTerritoryId

                LEFT JOIN dbo.tblTerritory T ON T.TerritoryId = sT.TerritoryId
                LEFT JOIN dbo.tblArea A ON A.AreaId = T.AreaId
                LEFT JOIN dbo.tblRegion R ON R.RegionId = A.RegionId
				LEFT JOIN dbo.tbl_Group G ON G.GroupId = R.GroupId
				left join tblMarketStationDetail dtl with (nolock) on dtl.MarketId=m.MarketId
				left join dbo.tblRoleType uRole with (nolock) on dtl.UserRoleID=uRole.RoleTypeId

				left join tblStationType stt with (nolock) on dtl.StationTypeId=stt.StationTypeId
				left join tbl_Thana tha with (nolock) on M.ThanaId=tha.ThanaId
				left join tbl_District dis with (nolock) on dis.DistrictId=tha.district_id
				left join tbl_Division div with (nolock) on dis.DivisionId=div.DivisionId




				WHERE m.MarketId=@id

    END

