

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_DoctorGMPxRecordMonthlyDashboard]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT

AS
BEGIN
   

   SELECT DoctorTypeName Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT DISTINCT DoctorTypeName,tbl_PrescriptionMaster.DoctorId FROM dbo.tbl_PrescriptionMaster
 
LEFT JOIN dbo.tblDoctorMaster ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_PrescriptionMaster.DoctorId
LEFT JOIN dbo.tblDoctorType ON dbo.tblDoctorType.DoctorTypeId=dbo.tblDoctorMaster.DoctorTypeId

WHERE MONTH(PrescriptionDate)=@Month AND YEAR(PrescriptionDate)=@Year  ) AS tblt
   GROUP BY DoctorTypeName

   
   




END

