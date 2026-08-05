-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DWSPApp]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt DATETIME =NULL,
	@ToDt DATETIME =NULL,
	@EmpId INT =NULL,
	@MonthValue INT=NULL,
	@YearValue INT=NULL
    
AS
    BEGIN
	--tblDWSPApprovalLog.Status NOT IN (''Accepted'',''Rejected'')
	DECLARE @params NVARCHAR(max)=' tblDWSPApprovalLog.TableId  is not null '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' tblDWSPApprovalLog.Status IN ('''+@AppStatus+''')'
		IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND tblDWSPApprovalLog.EntryDateApp='''+@FromDt+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND tblDWSPApprovalLog.EntryDateApp between '''+@FromDt+''' AND '''+@ToDt+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND mas.EntryDate='''+@FromDt+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND mas.EntryDate between '''+@FromDt+''' AND '''+@ToDt+''' '
		END
    END
	
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND mas.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	END
	IF(@MonthValue IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND mas.MonthValue='+convert(nvarchar(max),@MonthValue)+' '
	END
	IF(@YearValue IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND mas.YearValue='+convert(nvarchar(max),@YearValue)+' '
	END

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='
		SELECT mas.FinalSubmitRemarks, toRole.RoleType WaitingForRole, usr.RoleName, dgs.DesigName,  case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified'' when mas.ApprovalStatus=''2'' then ''Approved'' when mas.ApprovalStatus=''3'' then ''Rejected''  else mas.ApprovalStatus end ApprovalStatusWeb,   emp.EmpInfoId,mas.DWSPMasterId,
       MonthValue ,
                  YearValue ,
                  
          
       
       mas.ApprovalStatus,
       
       
       tblDWSPApprovalLog.DWSPApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblDWSPApprovalLog.TableId,
       tblDWSPApprovalLog.Status,
       Comments,
       Type,
       Step,
       tblDWSPApprovalLog.GroupId,
       tblDWSPApprovalLog.RegionId,
       tblDWSPApprovalLog.AreaId,
       tblDWSPApprovalLog.TerritoryId,
       
       tblDWSPApprovalLog.RoleTypeId,tblDWSPApprovalLog.ToRoleTypeId,
       
       
       emp.EmpMasterCode,
       emp.EmpName,
	   View_Webapi_EmployeeFieldForceInfo.TerritoryId,
                                 View_Webapi_EmployeeFieldForceInfo.AreaId,
                                 View_Webapi_EmployeeFieldForceInfo.RegionId,
                                 View_Webapi_EmployeeFieldForceInfo.GroupId,
                                 View_Webapi_EmployeeFieldForceInfo.TerritoryName,
                                 TerritoryCode,
                                 AreaCode,
                                 View_Webapi_EmployeeFieldForceInfo.AreaName,
                                 RegionCode,
                                 View_Webapi_EmployeeFieldForceInfo.RegionName,
                                 View_Webapi_EmployeeFieldForceInfo.GroupName,
                                 MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep 
	   
	   
	   FROM dbo.tbl_DWSPMaster mas
	     
LEFT JOIN dbo.tblDWSPApprovalLog ON dbo.tblDWSPApprovalLog.TableId=mas.DWSPMasterId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblDWSPApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblDWSPApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = mas.EmpInfoId
left JOIN dbo.tblUser us ON us.EmpInfoId = mas.EmpInfoId
 
left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = emp.DesignationId
left JOIN dbo.tblRoleType toRole ON tblDWSPApprovalLog.ToRoleTypeId = usr.RoleTypeId

LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = emp.EmpInfoId

 left join (select TableId,RoleTypeId from tblDWSPApprovalLog  with (nolock) where Step=1) as tblrole on mas.DWSPMasterId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE '+@params+' AND  tblRoleType.RoleType<>'''+@Role+'''  AND Step=LogMax.MaxStep  '

EXEC sys.sp_executesql @Q


    END


