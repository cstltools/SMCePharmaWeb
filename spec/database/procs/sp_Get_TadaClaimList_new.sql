-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TadaClaimList_new]
	-- Add the parameters for the stored procedure here
	@param nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='SELECT  distinct  mas.TadaDate TadaDatesss, (SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''DAClaimMy'')+CAST(mas.TadaID as nvarchar(max))+''.jpg'' AS   ImageString,  tblappDate.Info ApproveDate, mas.TadaID , mas.HotelName, mas.HotelPhone,  tblapp.Info ApprovalLog,us.UserRoleID, format(mas.TadaDate,''dd-MMM-yyyy'')AS TadaDate, emp.EmpMasterCode,emp.EmpName, 0 TaAmt, mas.DAAmount DaAmt,mar.MarketCode, mar.MarketName MarketName, st.StationTypeName,   case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified'' when mas.ApprovalStatus=''2'' then ''Approved'' when mas.ApprovalStatus=''3'' then ''Rejected''  else mas.ApprovalStatus end  ApprovalStatus, empUserEntry.EmpName + ISNULL('' (''+uRREntry.RoleName+'')'','''') CreateBy, format(mas.EntryDate,''dd-MMM-yyyy hh:mm tt'')AS EntryDate,  empUserUp.EmpName + ISNULL('' (''+uRRUp.RoleName+'')'','''') UpdateBy, format(mas.UpdateDate,''dd-MMM-yyyy hh:mm tt'')AS UpdateDate     FROM  [dbo].[tbl_TadaClaimMaster] mas with (nolock)
 
left JOIN dbo.tblEmpGeneralInfo emp  with (nolock) ON emp.EmpInfoId=mas.EmpInfoId
 LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo v   with (nolock) ON v.EmpInfoId = emp.EmpInfoId
left JOIN dbo.tblStationType st  with (nolock) ON st.StationTypeId=mas.TourTypeId

 
left JOIN dbo.tblMarket mar  with (nolock) ON mar.MarketId = mas.MarketId
left JOIN dbo.tblUser us  with (nolock) ON us.EmpInfoId=mas.EmpInfoId
left JOIN dbo.tblUser usEntry  with (nolock) ON usEntry.UserId=mas.EntryBy
left JOIN dbo.tblEmpGeneralInfo empUserEntry  with (nolock) ON empUserEntry.EmpInfoId=usEntry.EmpInfoId

 left join tbl_UserRoleInfo uRREntry  with (nolock) on uRREntry.UserRoleID=usEntry.UserRoleID
 left JOIN dbo.tblUser usUp  with (nolock) ON usUp.UserId=mas.UpdateBy
left JOIN dbo.tblEmpGeneralInfo empUserUp  with (nolock) ON empUserUp.EmpInfoId=usUp.EmpInfoId

 left join tbl_UserRoleInfo uRRUp  with (nolock) on uRRUp.UserRoleID=usUp.UserRoleID

left join (SELECT tblt.TableId, SUBSTRING(tblt.Info,2,LEN(tblt.Info))Info  FROM (SELECT 
   SS.TableId, 
   (SELECT '', '' + case when US.Status=''Rejected'' then  empUserapp.EmpName + ISNULL('' (''+usappEntry.RoleName+'')'','''')+    ISNULL('' [Rejected Remarks: ''+US.Comments+'']'','''') else  empUserapp.EmpName + ISNULL('' (''+usappEntry.RoleName+'')'','''') end
    FROM dbo.tblTADAApprovalLog US  with (nolock)
	 
	left JOIN dbo.tblEmpGeneralInfo empUserapp  with (nolock) ON empUserapp.EmpInfoId=US.EntryByApp

	
	 LEFT JOIN tblUser usapp  with (nolock)  ON usapp.EmpInfoId=US.EntryByApp
 left join tbl_UserRoleInfo usappEntry  with (nolock) on usappEntry.UserRoleID=usapp.UserRoleID




    WHERE US.TableId = SS.TableId and (US.Status=''Rejected'' or US.Status=''Accepted'')
    FOR XML PATH('''')) [Info]
FROM dbo.tblTADAApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblapp on tblapp.TableId=mas.TadaID


left join (SELECT tblt.TableId, SUBSTRING(tblt.Info,2,LEN(tblt.Info))Info  FROM (SELECT 
   SS.TableId, 
   (SELECT '', '' +format(isnull(US.Date,US.EntryDateS),''dd-MMM-yyyy hh:mm tt'')  
    FROM dbo.tblTADAApprovalLog US  with (nolock)
	 
	 



    WHERE US.TableId = SS.TableId and (US.Status=''Rejected'' or US.Status=''Accepted'')
    FOR XML PATH('''')) [Info]
FROM dbo.tblTADAApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblappDate on tblappDate.TableId=mas.TadaID



WHERE mas.TadaID IS NOT NULL 
 '+@param  +' order by mas.TadaDate desc'


EXEC sp_executesql @Q
	
END

