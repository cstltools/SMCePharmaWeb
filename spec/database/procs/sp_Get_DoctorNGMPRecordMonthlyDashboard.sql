

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_DoctorNGMPRecordMonthlyDashboard]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT

AS
BEGIN
   

   SELECT ComUnitName Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT DISTINCT ComUnitName,tbl_DCRInfo.DoctorId FROM dbo.tbl_DCRInfo
LEFT JOIN dbo.tblDcWiseTerritoryDetail ON tblDcWiseTerritoryDetail.TerritoryId = tbl_DCRInfo.TerritoryId
LEFT JOIN dbo.tblDcWiseTerritoryMaster ON tblDcWiseTerritoryMaster.DcWiseTerritoryMasterId = tbl_DCRInfo.DcrId
LEFT JOIN dbo.tblCompanyUnit ON dbo.tblCompanyUnit.ComUnitId=dbo.tblDcWiseTerritoryMaster.DCId
LEFT JOIN dbo.tblDoctorMaster ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_DCRInfo.DoctorId
WHERE MONTH(DcrDate)=@Month AND YEAR(DcrDate)=@Year AND DoctorTypeId='1' ) AS tblt
   GROUP BY ComUnitName

   
   




END

