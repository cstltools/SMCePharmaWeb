CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanInfoDetail_new] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	-- Add the parameters for the stored procedure here
@month INT = NULL,
@year INT = NULL,
@empId INT = NULL,
@Date NVARCHAR(max) = NULL
AS
BEGIN
	
	SELECT ISNULL(cast( A.VisitedWithEmpInfoId    as nvarchar(max)),'')  VisitedWithEmpInfoId, isnull(v_emp.EmpName +' : '+v_emp.EmpMasterCode,'') VisitedWithEmpName,  cast(ISNULL([IsMorning],0) as nvarchar(max))  IsMorning
      ,cast( case when ISNULL([IsEvening],0)=1 then '1' else '0' end as nvarchar(max)) IsEvening
      ,cast( case when ISNULL(A.IsMarketVisit,0)=1 then '1' else '0' end as nvarchar(max)) IsMarketVisit
      ,cast( case when ISNULL(A.IsOtherVisit,0)=1 then '1' else '0' end as nvarchar(max)) IsOtherVisit
      ,cast(  case when ISNULL([IsStartTime],0)=1 then '1' else '0' end  as nvarchar(max)) IsStartTime
      ,cast(ISNULL(A.[Starttime],'')as nvarchar(max)) Starttime
      ,cast(  case when ISNULL([IsEndtime],0)=1 then '1' else '0' end  as nvarchar(max)) IsEndtime
      ,cast(ISNULL(A.[Endtime],'')as nvarchar(max)) Endtime , tpM.ApprovalStatus, A.TourTypeId,A.TPId,A.EmpInfoId, tpM.TPMaster, A.TourPlanId ,    
           isnull(A.Comment,'') Comment ,
           A.IsMarketWise ,
           A.IsApproved,
		   
		    
		   ISNULL(D.ShiftText,'')  ShiftText,
		    --ISNULL( E.TourTypeName,'') TourTypeName,
		    ISNULL( E.StationTypeName,'') TourTypeName,
		   ISNULL( F.TPName,'') TPName,
		   MONTH(A.TourPlanDate) AS MonthValue,
		   YEAR(A.TourPlanDate) AS YearValue,
		   DAY(A.TourPlanDate) AS DayValue,
		   	Convert(varchar(10), A.TourPlanDate,120) AS TourPlanDate,
			tpM.IsFinalSubmit, A.SerialNo, A.GroupId, gr.GroupName GroupName,A.RegionId,  rg.RegionName  RegionName, A.AreaId, ar.AreaName AreaName, A.TerritoryId,tr.TerritoryCode+ ' : ' + tr.TerritoryName TerritoryName, A.SubTerritoryId, subtr.SubTerritoryName SubTerritoryName,A.MarketId, A.MarketIdEnd ,  A.MarketName ,   A.MarketNameEnd, isnull(A.Objective,'') Objective
			
		    
		    FROM dbo.tbl_TourPlanInfo A  with (nolock) 
		 
			LEFT JOIN dbo.tblEmpGeneralInfo v_emp  with (nolock)  ON v_emp.EmpInfoId = A.VisitedWithEmpInfoId
		 
			LEFT JOIN dbo.tbl_Shift D  with (nolock)  ON D.ShiftId = A.ShiftId
			--LEFT JOIN dbo.tbl_TourPlanType E  with (nolock)  ON E.TourTypeId = A.TourTypeId
			LEFT JOIN dbo.tblStationType E  with (nolock)  ON E.StationTypeId = A.TourTypeId
			LEFT JOIN dbo.tbl_TourPlanPurpose F  with (nolock)  ON F.TPId = A.TPId
			INNER JOIN dbo.tbl_TourPlanMaster tpM  with (nolock)  ON tpM.TPMaster = A.TPMaster

			left join tblSubTerritory subtr  with (nolock) on subtr.SubTerritoryId =A.SubTerritoryId
	left join tblTerritory tr  with (nolock) on tr.TerritoryId =A.TerritoryId
	left join tblArea ar  with (nolock) on ar.AreaId =A.AreaId
	left join tblRegion rg  with (nolock) on rg.RegionId=A.RegionId

	left join tbl_Group gr  with (nolock) on gr.GroupId=A.GroupId

			WHERE A.EmpInfoId = @empId AND CONVERT(DATE,A.TourPlanDate) = CONVERT(DATE,@Date)
END
