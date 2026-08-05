-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_PrescriptionList_ForApproval]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   Select  PM.PrescriptionId,CONVERT(NVARCHAR(50),PM.PrescriptionDate,106)AS PrescriptionDate, PT.PrescriptionType, DM.DoctorName, Us.UserName,PM.ApprovalStatus from tbl_PrescriptionMaster PM
   Left join tbl_PrescriptionType PT On PM.PrescriptionTypeId= PT.PrescriptionTypeId
   Left join tblDoctorMaster DM ON PM.DoctorId = DM.DoctorId
   Left Join tblUser Us ON PM.EntryBy= Us.UserId
   Where PM.ApprovalStatus !='Approved'


END
