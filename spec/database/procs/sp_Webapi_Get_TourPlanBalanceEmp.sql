
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanBalanceEmp] -- Add the parameters for the stored procedure here
 @EmpInfoId nvarchar(max),@Month nvarchar(max), @year nvarchar(max)
AS
BEGIN
	select  emp.EmpMasterCode, mas.EmpInfoId, tblStationType.StationTypeName, COUNT(mas.TourTypeId) Balance from tbl_TadaClaimMaster mas
	inner JOIN dbo.tblStationType ON tblStationType.StationTypeId = mas.TourTypeId
	inner join tblEmpGeneralInfo emp on mas.EmpInfoId=emp.EmpInfoId
	   WHERE mas.EmpInfoId in( select * from fnSplit(@EmpInfoId,',')) and MONTH(mas.TadaDate)=@Month AND YEAR(mas.TadaDate)=@year and mas.ApprovalStatus='2'

	   group by  emp.EmpMasterCode, mas.EmpInfoId, tblStationType.StationTypeName


--	SELECT emp.EmpMasterCode, tblt.EmpInfoId, tblt.StationTypeId,tblt.StationTypeName, (CountNo-tblt.Amount) Amount,CountNo,tblt.Amount Balance FROM (SELECT StationTypeId,StationTypeName,COUNT(TourPlanId)Amount,EmpInfoId FROM tbl_TourPlanInfo
--inner JOIN dbo.tblStationType ON tblStationType.StationTypeId = tbl_TourPlanInfo.TourTypeId
--WHERE SerialNo='1' AND MONTH(TourPlanDate)=@Month AND EmpInfoId in( select * from fnSplit(@EmpInfoId,','))  AND YEAR(TourPlanDate)=@year
--GROUP BY StationTypeId,StationTypeName,EmpInfoId)AS tblt
--LEFT JOIN dbo.tblTourSetupEmployee ON tblTourSetupEmployee.EmpInfoId = tblt.EmpInfoId AND tblTourSetupEmployee.StationTypeId = tblt.StationTypeId
--inner join tblEmpGeneralInfo emp on tblt.EmpInfoId=emp.EmpInfoId

--WHERE tblt.EmpInfoId in( select * from fnSplit(@EmpInfoId,','))


END


