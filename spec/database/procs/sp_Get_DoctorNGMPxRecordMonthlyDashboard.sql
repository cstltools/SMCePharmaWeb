

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_DoctorNGMPxRecordMonthlyDashboard]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT

AS
BEGIN
   

   SELECT ComUnitName Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT DISTINCT ComUnitName,tbl_PrescriptionMaster.DoctorId FROM dbo.tbl_PrescriptionMaster
LEFT JOIN dbo.tblDcWiseTerritoryDetail ON tblDcWiseTerritoryDetail.TerritoryId = tbl_PrescriptionMaster.TerritoryId
LEFT JOIN dbo.tblDcWiseTerritoryMaster ON tblDcWiseTerritoryMaster.DcWiseTerritoryMasterId = tblDcWiseTerritoryDetail.DcWiseTerritoryMasterId
LEFT JOIN dbo.tblCompanyUnit ON dbo.tblCompanyUnit.ComUnitId=dbo.tblDcWiseTerritoryMaster.DCId
LEFT JOIN dbo.tblDoctorMaster ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_PrescriptionMaster.DoctorId
WHERE MONTH(PrescriptionDate)=@Month AND YEAR(PrescriptionDate)=@Year AND DoctorTypeId='1' ) AS tblt
   GROUP BY ComUnitName

   
   




END

