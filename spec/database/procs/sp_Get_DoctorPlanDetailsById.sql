-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorPlanDetailsById]
	-- Add the parameters for the stored procedure here
	@id INT
AS
BEGIN
 
SELECT  dtl.Type_DV, emp.EmpMasterCode +' : '+emp.EmpName EmpName,  dgs.DesigName,  CONVERT(NVARCHAR(50),dtl.TourPlanDate,106)AS  TourPlanDate,   dtl.DoctorName_DV   DoctorName ,  dtl.Comment,  * FROM dbo.tbl_DoctorTourPlanMaster mas
INNER JOIN tbl_DoctorTourPlanDetail dtl ON dtl.DocTPMaster = mas.DocTPMaster
  
 
 left JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = mas.EmpInfoId

left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = emp.DesignationId



 WHERE mas.DocTPMaster=@id  
		ORDER BY  dtl.TourPlanDate,dtl.Type_DV   asc
END 