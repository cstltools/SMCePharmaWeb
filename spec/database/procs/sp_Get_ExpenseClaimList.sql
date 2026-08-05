-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ExpenseClaimList]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
   
 
   DECLARE @Query NVARCHAR(MAX)

SET @Query = 'SELECT  distinct Amount, Remarks, uRREntry.RoleName, DesigName, mas.ExpenseClaimID, tblappDate.Info ApproveDate,tblapp.Info ApprovalLog,empUserEntry.EmpName + ISNULL('' (''+uRREntry.RoleName+'')'','''') CreateBy, 
format(mas.EntryDate,''dd-MMM-yyyy hh:mm tt'')AS EntryDate, empUserUp.EmpName + ISNULL('' (''+uRRUp.RoleName+'')'','''') UpdateBy, format(mas.UpdateDate,''dd-MMM-yyyy hh:mm tt'')AS UpdateDate , 
(SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''ExpenseMy'')+CAST(mas.ExpenseClaimID as nvarchar(max))+''.jpg'' AS   ImageString, 
case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified''  when mas.ApprovalStatus=''2'' then ''Approved''  WHEN mas.ApprovalStatus=''3'' then ''Rejected''  
else mas.ApprovalStatus end ApprovalStatus,mas.EmpInfoId, us.UserRoleID, et.ExpenseTypeName TypeName,  format(mas.ExpenseDate,''dd-MMM-yyyy'')  AS ExpenseDate , emp.EmpName, emp.EmpMasterCode  
		  FROM dbo.tbl_ExpenseClaim mas
		  LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=mas.EmpInfoId
		  		   LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo v   with (nolock) ON v.EmpInfoId = emp.EmpInfoId
		  LEFT JOIN dbo.tblUser us ON emp.EmpInfoId=us.EmpInfoId
		  left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
		  LEFT JOIN dbo.tbl_ExpenseTypeMaster et ON et.ExpenseTypeId=mas.ExpenseTypeId
		  left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = emp.DesignationId


		    left JOIN dbo.tblUser usEntry  with (nolock) ON usEntry.UserId=mas.EntryBy
left JOIN dbo.tblEmpGeneralInfo empUserEntry  with (nolock) ON empUserEntry.EmpInfoId=usEntry.EmpInfoId

 left join tbl_UserRoleInfo uRREntry  with (nolock) on uRREntry.UserRoleID=usEntry.UserRoleID
 left JOIN dbo.tblUser usUp  with (nolock) ON usUp.UserId=mas.UpdateBy
left JOIN dbo.tblEmpGeneralInfo empUserUp  with (nolock) ON empUserUp.EmpInfoId=usUp.EmpInfoId

 left join tbl_UserRoleInfo uRRUp  with (nolock) on uRRUp.UserRoleID=usUp.UserRoleID

left join (SELECT tblt.TableId, SUBSTRING(tblt.Info,2,LEN(tblt.Info))Info  FROM (SELECT 
   SS.TableId, 
   (SELECT '', '' + case when US.Status=''Rejected'' then  empUserapp.EmpName + ISNULL('' (''+usappEntry.RoleName+'')'','''')+    ISNULL('' [Rejected Remarks: ''+US.Comments+'']'','''') else  empUserapp.EmpName + ISNULL('' (''+usappEntry.RoleName+'')'','''') end
    FROM dbo.tblExpanseApprovalLog US  with (nolock)
	 
	left JOIN dbo.tblEmpGeneralInfo empUserapp  with (nolock) ON empUserapp.EmpInfoId=US.FromEmpId

	LEFT JOIN tblUser usapp  with (nolock)  ON usapp.EmpInfoId=US.FromEmpId
 left join tbl_UserRoleInfo usappEntry  with (nolock) on usappEntry.UserRoleID=usapp.UserRoleID



    WHERE US.TableId = SS.TableId and (US.Status=''Rejected'' or US.Status=''Accepted'')
    FOR XML PATH('''')) [Info]
FROM dbo.tblExpanseApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblapp on tblapp.TableId=mas.ExpenseClaimID


left join (SELECT tblt.TableId, SUBSTRING(tblt.Info,2,LEN(tblt.Info))Info  FROM (SELECT 
   SS.TableId, 
   (SELECT '', '' +format(isnull(US.Date, (isnull( US.EntryDateS, US.EntryDateApp))),''dd-MMM-yyyy hh:mm tt'')  
    FROM dbo.tblExpanseApprovalLog US  with (nolock)
	 
	 



    WHERE US.TableId = SS.TableId and (US.Status=''Rejected'' or US.Status=''Accepted'')
    FOR XML PATH('''')) [Info]
FROM dbo.tblExpanseApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblappDate on tblappDate.TableId=mas.ExpenseClaimID



	
		 	  WHERE mas.ExpenseClaimID IS NOT NULL '+  @param+ ' order by format(mas.ExpenseDate,''dd-MMM-yyyy'') desc'
 
END

EXEC (@Query)
