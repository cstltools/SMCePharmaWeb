-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorList_Approval]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   SELECT    CONVERT(NVARCHAR(50),DM.EntryDate,106)AS EntryDate,  dgs.DesigName,     DM.DoctorName,   Us.UserName as UserEntryBy,  Up.UserName UserUpdateBy, STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm (NOLOCK) INNER JOIN dbo.tblDoctorDegreeDetail mgd ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS DegreeName,  STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm (NOLOCK) INNER JOIN dbo.tblDoctorSpecialityDetail mgd ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,'') as DoctorSpeciality ,  STUFF( (SELECT CONCAT(',', mm.ProgramType , '') FROM tblDoctorProgramType mm (NOLOCK) INNER JOIN dbo.tblDoctorProgramTypeDetail mgd ON mgd.ProgramTypeId=mm.ProgramTypeId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd. DoctorTypeDetailId FOR XML PATH ('') ),1,1,'') as ProgramType, * from tblDoctorMaster DM
   Left Join dbo.tblDesignation dgs ON dgs.DesignationId= DM.DesignationId
   Left Join dbo.tblDoctorProgramType pt ON pt.ProgramTypeId= DM.ProgramType
  
   Left Join tblUser Us ON DM.EntryBy= Us.UserId
   Left Join tblUser Up ON DM.UpdateBy= Up.UserId
   Where ApprovalStatus != 'Approved'   
   ORDER BY DM.DoctorCode DESC

END
