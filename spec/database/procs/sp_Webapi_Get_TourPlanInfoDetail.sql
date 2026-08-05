CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanInfoDetail] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	-- Add the parameters for the stored procedure here
@month INT = NULL,
@year INT = NULL,
@empId INT = NULL,
@Date NVARCHAR(max) = NULL
AS
BEGIN
	
	SELECT ISNULL(cast( A.VisitedWithEmpInfoId    as nvarchar(max)),'')  VisitedWithEmpInfoId, isnull(v_emp.EmpName +' : '+v_emp.EmpMasterCode,'') VisitedWithEmpName,  cast(ISNULL([IsMorning],0) as nvarchar(max))  IsMorning
      ,cast(ISNULL([IsEvening],0) as nvarchar(max)) IsEvening
      ,cast(ISNULL([IsStartTime],0)as nvarchar(max)) IsStartTime
      ,cast(ISNULL([Starttime],'')as nvarchar(max)) Starttime
      ,cast(ISNULL([IsEndtime],0)as nvarchar(max)) IsEndtime
      ,cast(ISNULL([Endtime],'')as nvarchar(max)) Endtime , tpM.ApprovalStatus, A.TourTypeId,A.TPId,A.EmpInfoId, tpM.TPMaster, A.TourPlanId ,    
           isnull(A.Comment,'') Comment ,
           A.IsMarketWise ,
           A.IsApproved,
		   
		    
		   ISNULL(D.ShiftText,'')  ShiftText,
		    ISNULL( E.TourTypeName,'') TourTypeName,
		   ISNULL( F.TPName,'') TPName,
		   MONTH(A.TourPlanDate) AS MonthValue,
		   YEAR(A.TourPlanDate) AS YearValue,
		   DAY(A.TourPlanDate) AS DayValue,
		   	Convert(varchar(10), A.TourPlanDate,120) AS TourPlanDate,
			tpM.IsFinalSubmit, A.SerialNo, A.GroupId, gr.GroupName GroupName,A.RegionId,  rg.RegionName  RegionName, A.AreaId, ar.AreaName AreaName, A.TerritoryId,tr.TerritoryCode+ ' : ' + tr.TerritoryName TerritoryName, A.SubTerritoryId, subtr.SubTerritoryName SubTerritoryName,A.MarketId,   B.MarketName
			
		    
		    FROM dbo.tbl_TourPlanInfo A  with (nolock) 
			LEFT JOIN dbo.tblMarket B  with (nolock)  ON B.MarketId = A.MarketId
			LEFT JOIN dbo.tblEmpGeneralInfo v_emp  with (nolock)  ON v_emp.EmpInfoId = A.VisitedWithEmpInfoId
		 
			LEFT JOIN dbo.tbl_Shift D  with (nolock)  ON D.ShiftId = A.ShiftId
			LEFT JOIN dbo.tbl_TourPlanType E  with (nolock)  ON E.TourTypeId = A.TourTypeId
			LEFT JOIN dbo.tbl_TourPlanPurpose F  with (nolock)  ON F.TPId = A.TPId
			INNER JOIN dbo.tbl_TourPlanMaster tpM  with (nolock)  ON tpM.TPMaster = A.TPMaster

			left join tblSubTerritory subtr  with (nolock) on subtr.SubTerritoryId =A.SubTerritoryId
	left join tblTerritory tr  with (nolock) on tr.TerritoryId =A.TerritoryId
	left join tblArea ar  with (nolock) on ar.AreaId =A.AreaId
	left join tblRegion rg  with (nolock) on rg.RegionId=A.RegionId

	left join tbl_Group gr  with (nolock) on gr.GroupId=A.GroupId

			WHERE A.EmpInfoId = @empId AND CONVERT(DATE,A.TourPlanDate) = CONVERT(DATE,@Date)
END
