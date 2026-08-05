-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_MileageClaimList_new]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
   
 
   DECLARE @Query NVARCHAR(MAX)

SET @Query = 'SELECT (SELECT LTRIM(RTRIM(ImagePath+''\''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType=''Mileage'')+CAST(mas.MileageClaimId AS NVARCHAR(max))+''.jpg''AS ImagePreName, case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified''  when mas.ApprovalStatus=''2'' then ''Approved''  WHEN mas.ApprovalStatus=''3'' then ''Rejected''  else mas.ApprovalStatus end ApprovalStatus, mas.EmpInfoId, us.UserRoleID, tr.TransportName,   ISNULL(mas.MileageInKM,0)  * ISNULL(mas.AllowedMileageInKM,0)  Expense, CONVERT(NVARCHAR(50),mas.MileageDate,106)AS MileageDate , emp.EmpName, emp.EmpMasterCode, *  
		  FROM dbo.tbl_MileageClaim mas
		  LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=mas.EmpInfoId
		  LEFT JOIN dbo.tblUser us ON emp.EmpInfoId=us.EmpInfoId
		 

		  LEFT JOIN dbo.tbl_Transport tr ON tr.TransportId=mas.TransportId


		  left JOIN dbo.tblUser usEntry  with (nolock) ON usEntry.UserId=mas.EntryByleft JOIN dbo.tblEmpGeneralInfo empUserEntry  with (nolock) ON empUserEntry.EmpInfoId=usEntry.EmpInfoId left join tbl_UserRoleInfo uRREntry  with (nolock) on uRREntry.UserRoleID=usEntry.UserRoleID left JOIN dbo.tblUser usUp  with (nolock) ON usUp.UserId=mas.UpdateByleft JOIN dbo.tblEmpGeneralInfo empUserUp  with (nolock) ON empUserUp.EmpInfoId=usUp.EmpInfoId left join tbl_UserRoleInfo uRRUp  with (nolock) on uRRUp.UserRoleID=usUp.UserRoleIDleft join (SELECT tblt.TableId, SUBSTRING(tblt.Info,2,LEN(tblt.Info))Info  FROM (SELECT    SS.TableId,    (SELECT '', '' + case when US.Status=''Rejected'' then  empUserapp.EmpName + ISNULL('' (''+usappEntry.RoleName+'')'','''')+    ISNULL('' [Rejected Remarks: ''+US.Comments+'']'','''') else  empUserapp.EmpName + ISNULL('' (''+usappEntry.RoleName+'')'','''') end    FROM dbo.tblMileageApprovalLog US  with (nolock)	 	left JOIN dbo.tblEmpGeneralInfo empUserapp  with (nolock) ON empUserapp.EmpInfoId=US.EntryByApp	LEFT JOIN tblUser usapp  with (nolock)  ON usapp.EmpInfoId=empUserapp.EmpInfoId left join tbl_UserRoleInfo usappEntry  with (nolock) on usappEntry.UserRoleID=usapp.UserRoleID    WHERE US.TableId = SS.TableId and (US.Status=''Rejected'' or US.Status=''Accepted'')    FOR XML PATH('''')) [Info]FROM dbo.tblMileageApprovalLog SSGROUP BY SS.TableId)AS tblt)  tblapp on tblapp.TableId=mas.TadaIDleft join (SELECT tblt.TableId, SUBSTRING(tblt.Info,2,LEN(tblt.Info))Info  FROM (SELECT    SS.TableId,    (SELECT '', '' +format(US.EntryDateS,''dd-MMM-yyyy hh:mm tt'')      FROM dbo.tblMileageApprovalLog US  with (nolock)	 	     WHERE US.TableId = SS.TableId and (US.Status=''Rejected'' or US.Status=''Accepted'')    FOR XML PATH('''')) [Info]FROM dbo.tblMileageApprovalLog SSGROUP BY SS.TableId)AS tblt)  tblappDate on tblappDate.TableId=mas.TadaID


		 	  WHERE mas.MileageClaimId IS NOT NULL


		 


'+  @param  +' ORDER BY mas.EntryDate desc '
 
END

EXEC (@Query)
