-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanApp]
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
	--tblTourPlanApprovalLog.Status NOT IN (''Accepted'',''Rejected'')
	DECLARE @params NVARCHAR(max)=' tblTourPlanApprovalLog.TableId  is not null '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' mas.ApprovalStatus IN ('''+@AppStatus+''')'
	 IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND mas.EntryDate='''+@FromDt+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND mas.EntryDate between '''+@FromDt+''' AND '''+@ToDt+''' '
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
		SELECT mas.FinalSubmitRemarks, toRole.RoleType WaitingForRole, usr.RoleName, dgs.DesigName,  case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified'' when mas.ApprovalStatus=''2'' then ''Approved'' when mas.ApprovalStatus=''3'' then ''Rejected''  else mas.ApprovalStatus end ApprovalStatusWeb,   emp.EmpInfoId,mas.TPMaster,
       MonthValue ,
                  YearValue ,
                  
          
       
       mas.ApprovalStatus,
       
       
       tblTourPlanApprovalLog.TourPlanApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblTourPlanApprovalLog.TableId,
       tblTourPlanApprovalLog.Status,
       Comments,
       Type,
       Step,
       0 GroupId,
       0 RegionId,
       0 AreaId,
       0 TerritoryId,
       
       tblTourPlanApprovalLog.RoleTypeId,tblTourPlanApprovalLog.ToRoleTypeId,
       
       
       emp.EmpMasterCode,
       emp.EmpName,
	   0 TerritoryId,
                                 0 AreaId,
                                 0 RegionId,
                                 0 GroupId,
                                 0 TerritoryName,
                              0   TerritoryCode,
                                0 AreaCode,
                                0 AreaName,
                                0 RegionCode,
                                0 RegionName,
                           0 GroupName,
                            MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep 
	   
	   
	   FROM dbo.tbl_TourPlanMaster mas
	     
LEFT JOIN dbo.tblTourPlanApprovalLog ON dbo.tblTourPlanApprovalLog.TableId=mas.TPMaster
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblTourPlanApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblTourPlanApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = mas.EmpInfoId
left JOIN dbo.tblUser us ON us.EmpInfoId = mas.EmpInfoId
 
left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = emp.DesignationId
left JOIN dbo.tblRoleType toRole ON tblTourPlanApprovalLog.ToRoleTypeId = usr.RoleTypeId

LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = emp.EmpInfoId

 left join (select TableId,RoleTypeId from tblTourPlanApprovalLog  with (nolock) where Step=1) as tblrole on mas.TPMaster=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE '+@params+' AND  tblRoleType.RoleType<>'''+@Role+'''  AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END


