





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_VisitPlanApp]
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
	 --tblTourPlanApprovalLog.TableId  is not null
	 ----tblVisitPlanApprovalLog.Status NOT IN (''Accepted'',''Rejected'')
	DECLARE @params NVARCHAR(max)=' tblVisitPlanApprovalLog.TableId  is not null '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' tblVisitPlanApprovalLog.Status IN ('''+@AppStatus+''')'
		IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND tblVisitPlanApprovalLog.EntryDateApp='''+@FromDt+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND tblVisitPlanApprovalLog.EntryDateApp between '''+@FromDt+''' AND '''+@ToDt+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND tbl_DoctorTourPlanMaster.EntryDate='''+@FromDt+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND tbl_DoctorTourPlanMaster.EntryDate between '''+@FromDt+''' AND '''+@ToDt+''' '
		END
    END
	
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND tbl_DoctorTourPlanMaster.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	END
	IF(@MonthValue IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND tbl_DoctorTourPlanMaster.MonthValue='+convert(nvarchar(max),@MonthValue)+' '
	END
	IF(@YearValue IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND tbl_DoctorTourPlanMaster.YearValue='+convert(nvarchar(max),@YearValue)+' '
	END
	DECLARE @Q NVARCHAR(MAX)
	SET @Q='

	SELECT   tblEmpGeneralInfo.EmpInfoId,tbl_DoctorTourPlanMaster.DocTPMaster,
       MonthValue ,
                  YearValue ,
                  
          
       
       tbl_DoctorTourPlanMaster.ApprovalStatus,
       
       
       tblVisitPlanApprovalLog.VisitPlanApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblVisitPlanApprovalLog.TableId,
       tblVisitPlanApprovalLog.Status,
       Comments,
       Type,
       Step,
       tblVisitPlanApprovalLog.GroupId,
       tblVisitPlanApprovalLog.RegionId,
       tblVisitPlanApprovalLog.AreaId,
       tblVisitPlanApprovalLog.TerritoryId,
       
       RoleTypeId,ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
       tblEmpGeneralInfo.EmpName,
	   View_Webapi_EmployeeFieldForceInfo.TerritoryId,
                                 View_Webapi_EmployeeFieldForceInfo.AreaId,
                                 View_Webapi_EmployeeFieldForceInfo.RegionId,
                                 View_Webapi_EmployeeFieldForceInfo.GroupId,
                                 TerritoryName,
                                 TerritoryCode,
                                 AreaCode,
                                 AreaName,
                                 RegionCode,
                                 RegionName,
                                 GroupName,
                                 MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep 
	   
	   
	   FROM dbo.tbl_DoctorTourPlanMaster
	     
LEFT JOIN dbo.tblVisitPlanApprovalLog ON dbo.tblVisitPlanApprovalLog.TableId=dbo.tbl_DoctorTourPlanMaster.DocTPMaster
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblVisitPlanApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblVisitPlanApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tbl_DoctorTourPlanMaster.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
WHERE '+@params+'  AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END







