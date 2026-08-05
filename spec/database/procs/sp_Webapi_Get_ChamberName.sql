
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE 
[dbo].[sp_Webapi_Get_ChamberName]
	-- Add the parameters for the stored procedure here
  @empid INT 

AS
BEGIN
	

	SELECT distinct tblDoctorChemberDetail.ChemberId  ChemberId,isnull(name,'N/A')  ChemberName, tblDoctorChemberDetail.DoctorId FROM dbo.tblDoctorChemberDetail with (nolock)
	inner JOIN dbo.View_DoctorMaster CV  with (nolock) ON CV.DoctorId=tblDoctorChemberDetail.DoctorId 
	inner JOIN dbo.tblDoctorMaster doc  with (nolock) ON doc.DoctorId=tblDoctorChemberDetail.DoctorId 
		where doc.ApprovalStatus='2' and (CV.NSMEmpInfoId=@empid OR CV.RSMEmpInfoId=@empid OR CV.ASMEmpInfoId=@empid OR CV.MIOEmpInfoId=@empid)
END


