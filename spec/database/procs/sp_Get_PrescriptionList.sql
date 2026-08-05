-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_PrescriptionList]
	-- Add the parameters for the stored procedure here

		@param NVARCHAR(max)
AS
BEGIN
 
    DECLARE @Query NVARCHAR(MAX)

 SET @Query = 'Select (SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''PrescriptionMy'')+CAST(PM.PrescriptionId as nvarchar(max))+''.jpg'' AS   ImageString,  case when PM.ApprovalStatus=''0'' then ''Pending''  when PM.ApprovalStatus=''1'' then ''Verified''  when PM.ApprovalStatus=''2'' then ''Approved''  WHEN PM.ApprovalStatus=''3'' then ''Rejected''  else PM.ApprovalStatus end ApprovalStatus,PM.PrescriptionId,FORMAT(PM.EntryDate,''dd-MMM-yyyy hh:mm tt'') PrescriptionDate, PT.PrescriptionType,DM.DoctorCode+'' : ''+ DM.DoctorName DoctorName, usr.RoleName, em.EmpMasterCode+'' : ''+em.EmpName createBy, PM.SMCType_RX, * from tbl_PrescriptionMaster PM with (nolock)
   Left join tbl_PrescriptionType PT  with (nolock) On PM.PrescriptionTypeId= PT.PrescriptionTypeId
   Left join tblDoctorMaster DM  with (nolock) ON PM.DoctorId = DM.DoctorId
   Left Join tblUser Us  with (nolock) ON PM.EntryBy= Us.UserId
   Left Join tblEmpGeneralInfo em  with (nolock) ON em.EmpInfoId= Us.EmpInfoId
   left JOIN View_Webapi_EmployeeFieldForceInfo on View_Webapi_EmployeeFieldForceInfo.EmpInfoId=em.EmpInfoId
   
left JOIN dbo.tbl_UserRoleInfo usr  with (nolock) ON usr.UserRoleID = us.UserRoleID
where PM.PrescriptionId is not null  
'+  @param  +' order by  PM.PrescriptionDate desc'
 
END

EXEC (@Query)

 
