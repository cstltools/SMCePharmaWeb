CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanInfo] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	-- Add the parameters for the stored procedure here
@month INT = NULL,
@year INT = NULL,
@empId INT = NULL
AS
BEGIN
	
	SELECT A.TourPlanId ,    
           A.Comment ,
           A.IsMarketWise ,
           A.IsApproved,
		
		   (C.CustomerCode + ' : '+C.CustomerName)AS CustomerName,
		   D.ShiftText,
		   E.TourTypeName,
		   F.TPName,
		   MONTH(A.TourPlanDate) AS MonthValue,
		   YEAR(A.TourPlanDate) AS YearValue,
		   DAY(A.TourPlanDate) AS DayValue,
		   	Convert(varchar(10), A.TourPlanDate,120) AS TourPlanDate,
			tpM.IsFinalSubmit, A.SerialNo, A.GroupId, gr.GroupName GroupName,A.RegionId,  rg.RegionName  RegionName, A.AreaId, ar.AreaName AreaName, A.TerritoryId, tr.TerritoryName TerritoryName, A.SubTerritoryId, subtr.SubTerritoryName SubTerritoryName,A.MarketId, B.MarketCode+ ' : '+  B.MarketName  +'  ['+st.StationTypeName +']' MarketName
			
		    
		    FROM dbo.tbl_TourPlanInfo A  with (nolock) 

			left JOIN dbo.tblStationType st  with (nolock)  ON st.StationTypeId=A.TourTypeId
			LEFT JOIN dbo.tblMarket B  with (nolock)  ON B.MarketId = A.MarketId
			LEFT JOIN dbo.tblCustMaster C   with (nolock)  ON C.CustomerMasterId = A.CustomerMasterId
			LEFT JOIN dbo.tbl_Shift D  with (nolock)  ON D.ShiftId = A.ShiftId
			LEFT JOIN dbo.tbl_TourPlanType E  with (nolock)  ON E.TourTypeId = A.TourTypeId
			LEFT JOIN dbo.tbl_TourPlanPurpose F  with (nolock)  ON F.TPId = A.TPId
			INNER JOIN dbo.tbl_TourPlanMaster tpM  with (nolock)  ON tpM.TPMaster = A.TPMaster

			left join tblMarket mar  with (nolock) on mar.MarketId =A.MarketId
	left join tblSubTerritory subtr  with (nolock) on subtr.SubTerritoryId =A.SubTerritoryId
	left join tblTerritory tr  with (nolock) on tr.TerritoryId =A.TerritoryId
	left join tblArea ar  with (nolock) on ar.AreaId =A.AreaId
	left join tblRegion rg  with (nolock) on rg.RegionId=A.RegionId

	left join tbl_Group gr  with (nolock) on gr.GroupId=A.GroupId

			WHERE A.EmpInfoId = @empId AND MONTH(A.TourPlanDate) = @month AND YEAR(A.TourPlanDate) = @year

			order by DAY(A.TourPlanDate) asc
END
