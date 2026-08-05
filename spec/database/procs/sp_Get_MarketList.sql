CREATE PROCEDURE [dbo].[sp_Get_MarketList]
 @Parameter NVARCHAR(max)
AS
    BEGIN
	DECLARE @Query NVARCHAR(MAX)
		SET @Query = 'SELECT ''RT-''+cast(rtmain.RouteInformationMasterId as nvarchar(max))+'' : ''+rtmain.RouteName RouteName,tblNSM.StationTypeName NSMStationType, tblMIO.StationTypeName MIOStationType,tblAM.StationTypeName AMStationType,tblDZSM.StationTypeName DZSMtationType, tblSalesAssistant.StationTypeName SalesAssistanceStationType, div.DivisionName,dis.DistrictName, tha.ThanaName,
		DPT.MarketId, R.RegionCode+'' : ''+ R.RegionName RegionName, R.RegionId, A.AreaId,A.AreaCode+'' : ''+  A.AreaName AreaName, T.TerritoryId, T.TerritoryCode+'' : ''+T.TerritoryName TerritoryName, ST.SubTerritoryCode+'' : ''+ST.SubTerritoryName SubTerritoryName, G.GroupId,  G.GroupCode+'' : ''+G.GroupName GroupName,	 DPT.MarketCode, DPT.MarketName, DPT.IsActive,
		CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
	        CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName 
		ELSE updateBy.EmpName  
		END as  EMPUpdateBy,
		    CASE  WHEN empAcIn.EmpName  Is Null  THEN  AcIN.UserName 
		ELSE empAcIn.EmpName  
		END as  EMPActiveInactiveBy,					
		CONVERT(NVARCHAR(50),DPT.EntryDate,106)AS EntryDatee,
		CONVERT(NVARCHAR(50),DPT.UpdateDate,106)AS UpdateDatee,
		CONVERT(NVARCHAR(50),DPT.acInAcDate,106)AS InactiveDatee
		
		FROM tblMarket AS DPT  with (nolock)
		LEFT JOIN dbo.tblRouteInformationMarketDetail rtMAs   with (nolock) ON rtMAs.MarketId = DPT.MarketId
		LEFT JOIN dbo.tblRouteInformationMaster rtmain   with (nolock) ON rtmain.RouteInformationMasterId = rtMAs.RouteInformationMasterId
	
		LEFT JOIN dbo.tblSubTerritory ST   with (nolock) ON ST.SubTerritoryId = DPT.SubTerritoryId
		LEFT JOIN dbo.tblTerritory T   with (nolock) ON T.TerritoryId = ST.TerritoryId
		LEFT JOIN dbo.tblArea A   with (nolock) ON A.AreaId=T.AreaId
		LEFT JOIN dbo.tblRegion R   with (nolock) ON R.RegionId = A.RegionId
		LEFT JOIN dbo.tbl_Group G     with (nolock) ON G.GroupId = R.GroupId
		LEFT JOIN tblUser us   with (nolock) ON us.UserId = DPT.EntryBy
		LEFT JOIN tblUser up   with (nolock) ON up.UserId = DPT.UpdateBy
		LEFT JOIN tblUser AcIN   with (nolock) ON AcIN.UserId = DPT.ActiveInactiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp   with (nolock)  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy   with (nolock)  ON updateBy.EmpInfoId = up.EmpInfoId
		LEFT JOIN tblEmpGeneralInfo empAcIn    with (nolock) ON  empAcIn.EmpInfoId = AcIN.EmpInfoId	
		
		LEFT JOIN tbl_Thana tha   with (nolock) ON tha.ThanaId = DPT.ThanaId
		LEFT JOIN tbl_District dis   with (nolock) ON tha.district_id = dis.DistrictId
		LEFT JOIN tbl_Division div   with (nolock) ON div.DivisionId = dis.DivisionId

		LEFT JOIN (select MarketId,st.StationTypeName  from tblMarketStationDetail dtl  with (nolock) 
		inner join  tblStationType st on st.StationTypeId=dtl.StationTypeId where dtl.UserRoleID=1) tblMIO ON tblMIO.MarketId = DPT.MarketId

		LEFT JOIN (select MarketId,st.StationTypeName  from tblMarketStationDetail dtl  with (nolock) 
		inner join  tblStationType st on st.StationTypeId=dtl.StationTypeId where dtl.UserRoleID=2) tblAM ON tblAM.MarketId = DPT.MarketId

		LEFT JOIN (select MarketId,st.StationTypeName  from tblMarketStationDetail dtl  with (nolock) 
		inner join  tblStationType st  with (nolock)   on st.StationTypeId=dtl.StationTypeId where dtl.UserRoleID=3) tblDZSM ON tblDZSM.MarketId = DPT.MarketId
		
		LEFT JOIN (select MarketId,st.StationTypeName  from tblMarketStationDetail dtl  with (nolock) 
		inner join  tblStationType st  with (nolock)   on st.StationTypeId=dtl.StationTypeId where dtl.UserRoleID=4) tblNSM ON tblNSM.MarketId = DPT.MarketId
		
		LEFT JOIN (select MarketId,st.StationTypeName  from tblMarketStationDetail dtl  with (nolock) 
		inner join  tblStationType st  with (nolock)   on st.StationTypeId=dtl.StationTypeId where dtl.UserRoleID=32) tblSalesAssistant ON tblSalesAssistant.MarketId = DPT.MarketId
		
		WHERE DPT.MarketId is not null	
		
		 ' + @Parameter +' 		order by DPT.MarketName  asc '
		
    END
	EXEC(@Query)
