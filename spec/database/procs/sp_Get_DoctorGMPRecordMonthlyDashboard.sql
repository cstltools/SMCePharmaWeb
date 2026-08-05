

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_DoctorGMPRecordMonthlyDashboard]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT 

AS
BEGIN
   

   SELECT DoctorTypeName Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT DISTINCT DoctorTypeName,tbl_DCRInfo.DoctorId FROM dbo.tbl_DCRInfo
 
LEFT JOIN dbo.tblDoctorMaster ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_DCRInfo.DoctorId
LEFT JOIN dbo.tblDoctorType ON dbo.tblDoctorType.DoctorTypeId=dbo.tblDoctorMaster.DoctorTypeId

WHERE MONTH(DcrDate)=@Month AND YEAR(DcrDate)=@Year  ) AS tblt
   GROUP BY DoctorTypeName

   
   




END

