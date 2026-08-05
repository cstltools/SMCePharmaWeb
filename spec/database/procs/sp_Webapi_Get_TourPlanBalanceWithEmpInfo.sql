
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanBalanceWithEmpInfo] -- Add the parameters for the stored procedure here
 @EmpInfoId INT,@Month INT, @year INT
AS
BEGIN
	declare @HQ int=0
	declare @ExHQ int=0
	declare @OS int=0
	declare @OSDCC int=0
	SELECT    @HQ=isnull(tblt.Amount,0)   FROM (SELECT StationTypeId,StationTypeName,COUNT(TourPlanId)Amount,EmpInfoId FROM tbl_TourPlanInfo
inner JOIN dbo.tblStationType ON tblStationType.StationTypeId = tbl_TourPlanInfo.TourTypeId
WHERE SerialNo='1' AND MONTH(TourPlanDate)=@Month AND EmpInfoId=@EmpInfoId  AND YEAR(TourPlanDate)=@year
GROUP BY StationTypeId,StationTypeName,EmpInfoId)AS tblt 
WHERE tblt.EmpInfoId=@EmpInfoId and tblt.StationTypeId=1


	SELECT    @ExHQ=isnull(tblt.Amount,0)   FROM (SELECT StationTypeId,StationTypeName,COUNT(TourPlanId)Amount,EmpInfoId FROM tbl_TourPlanInfo
inner JOIN dbo.tblStationType ON tblStationType.StationTypeId = tbl_TourPlanInfo.TourTypeId
WHERE SerialNo='1' AND MONTH(TourPlanDate)=@Month AND EmpInfoId=@EmpInfoId  AND YEAR(TourPlanDate)=@year
GROUP BY StationTypeId,StationTypeName,EmpInfoId)AS tblt 
WHERE tblt.EmpInfoId=@EmpInfoId and tblt.StationTypeId=2


	SELECT    @OS=isnull(tblt.Amount,0)   FROM (SELECT StationTypeId,StationTypeName,COUNT(TourPlanId)Amount,EmpInfoId FROM tbl_TourPlanInfo
inner JOIN dbo.tblStationType ON tblStationType.StationTypeId = tbl_TourPlanInfo.TourTypeId
WHERE SerialNo='1' AND MONTH(TourPlanDate)=@Month AND EmpInfoId=@EmpInfoId  AND YEAR(TourPlanDate)=@year
GROUP BY StationTypeId,StationTypeName,EmpInfoId)AS tblt 
WHERE tblt.EmpInfoId=@EmpInfoId and tblt.StationTypeId=3



	SELECT    @OSDCC=isnull(tblt.Amount,0)   FROM (SELECT StationTypeId,StationTypeName,COUNT(TourPlanId)Amount,EmpInfoId FROM tbl_TourPlanInfo
inner JOIN dbo.tblStationType ON tblStationType.StationTypeId = tbl_TourPlanInfo.TourTypeId
WHERE SerialNo='1' AND MONTH(TourPlanDate)=@Month AND EmpInfoId=@EmpInfoId  AND YEAR(TourPlanDate)=@year
GROUP BY StationTypeId,StationTypeName,EmpInfoId)AS tblt 
WHERE tblt.EmpInfoId=@EmpInfoId and tblt.StationTypeId=7





select @HQ  HQ,@ExHQ  ExHQ,@OS  OS,@OSDCC  OSDCC, @HQ+@ExHQ+@OS  Total




END 