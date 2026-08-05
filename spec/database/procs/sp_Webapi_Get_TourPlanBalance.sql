
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanBalance] -- Add the parameters for the stored procedure here
 @EmpInfoId INT,@Month INT, @year INT
AS
BEGIN
	
	SELECT tblt.StationTypeId,tblt.StationTypeName, (CountNo-tblt.Amount) Amount,CountNo,tblt.Amount Balance FROM (SELECT StationTypeId,StationTypeName,COUNT(TourPlanId)Amount,EmpInfoId FROM tbl_TourPlanInfo
inner JOIN dbo.tblStationType ON tblStationType.StationTypeId = tbl_TourPlanInfo.TourTypeId
WHERE SerialNo='1' AND MONTH(TourPlanDate)=@Month AND EmpInfoId=@EmpInfoId  AND YEAR(TourPlanDate)=@year
GROUP BY StationTypeId,StationTypeName,EmpInfoId)AS tblt
LEFT JOIN dbo.tblTourSetupEmployee ON tblTourSetupEmployee.EmpInfoId = tblt.EmpInfoId AND tblTourSetupEmployee.StationTypeId = tblt.StationTypeId
WHERE tblt.EmpInfoId=@EmpInfoId


END


