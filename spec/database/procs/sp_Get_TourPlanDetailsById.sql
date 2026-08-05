-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TourPlanDetailsById]
	-- Add the parameters for the stored procedure here
	@id INT
AS
BEGIN
 

 declare @Month nvarchar(max)
 declare @year nvarchar(max)
 declare @EmpInfoId nvarchar(max)
 SELECT @Month=MONTH(TourPlanDate),@year=YEAR(TourPlanDate),@EmpInfoId= EmpInfoId FROM tbl_TourPlanInfo dtl WHERE  dtl.TPMaster =@id

 PRINT  @Month
 PRINT  @year
 PRINT  @EmpInfoId


SELECT empv.EmpMasterCode+' : '+empv.EmpName VisitedWithEmp, mas.MonthValue, mas.YearValue, mas.EmpInfoId,  isnull(tt.TPName,'') StationTypeName,'' Balance, 
 emp.EmpMasterCode +' : '+emp.EmpName EmpName,  dgs.DesigName,  CONVERT(NVARCHAR(50),dtl.TourPlanDate,106)AS  TourPlanDate, 
case when dtl.IsOtherVisit=1 then 'Other Visit' else 'Market Visit ['  +case when dtl.IsMorning=1 then 'Morning' when dtl.IsEvening=1 then 'Evening'     end  +']' end   
 MarketWise  , dtl.MarketCode_TP+ ' : ' + dtl.MarketName + isnull(' [Time: '+ dtl.Starttime +']','')MarketName,

  dtl.MarketCode_TPEnd+ ' : ' + dtl.MarketNameEnd + isnull(' [Time: '+ dtl.Endtime+']' ,'')MarketNameEnd, isnull(Objective,'') Objective,

STUFF( (SELECT  CONCAT( ', ' +   mm.MarketCode +' : '+mm.MarketName , '') FROM tblMarket mm (NOLOCK) INNER JOIN dbo.tblTPMarketDetail mgd ON mgd.MarketId=mm.MarketId WHERE mgd.TourPlanId=dtl.TourPlanId ORDER BY mgd.MarketId FOR XML PATH ('') ),1,1,'') as   CustomerName, tt.TPName TourTypeName, dtl.Comment,  * FROM dbo.tbl_TourPlanMaster mas
INNER JOIN tbl_TourPlanInfo dtl ON dtl.TPMaster = mas.TPMaster
--LEFT  JOIN dbo.tblMarket mk ON mk.MarketId = dtl.MarketId
--LEFT  JOIN dbo.tblCustMaster cus ON cus.CustomerMasterId = dtl.CustomerMasterId
LEFT  JOIN dbo.tbl_TourPlanPurpose tt ON tt.TPID = dtl.TPID
left JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = mas.EmpInfoId
left JOIN dbo.tblEmpGeneralInfo empv ON empv.EmpInfoId = dtl.VisitedWithEmpInfoId

left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = emp.DesignationId
left JOIN dbo.tblStationType stType ON stType.StationTypeId = dtl.TourTypeId

--left join (	SELECT tblt.EmpInfoId, tblt.StationTypeId,tblt.StationTypeName,tblt.Amount Balance FROM (SELECT  StationTypeId,StationTypeName,COUNT(TourPlanId)Amount,EmpInfoId FROM tbl_TourPlanInfo
--inner JOIN dbo.tblStationType ON tblStationType.StationTypeId = tbl_TourPlanInfo.TourTypeId
--WHERE SerialNo='1' AND MONTH(TourPlanDate)=@Month AND EmpInfoId=@EmpInfoId  AND YEAR(TourPlanDate)=@year
--GROUP BY StationTypeId,StationTypeName,EmpInfoId)AS tblt
--LEFT JOIN dbo.tblTourSetupEmployee ON tblTourSetupEmployee.EmpInfoId = tblt.EmpInfoId AND tblTourSetupEmployee.StationTypeId = tblt.StationTypeId
--WHERE tblt.EmpInfoId=@EmpInfoId) tblst on tblst.EmpInfoId=mas.EmpInfoId

 WHERE  mas.TPMaster=@id

 ORDER BY dtl.TourPlanDate asc, dtl.IsMorning desc
		
END
