



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ExpanseClaimApp]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt NVARCHAR(MAX) =NULL,
	@ToDt NVARCHAR(MAX) =NULL,
	@EmpId INT =NULL
AS
    BEGIN
	

	

 DECLARE @params3 NVARCHAR(max)=''
	DECLARE @params NVARCHAR(max)='   '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' '
		IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(date,tblExpanseApprovalLog.EntryDateApp)='''+@FromDt+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(date,tblExpanseApprovalLog.EntryDateApp) between '''+@FromDt+''' AND '''+@ToDt+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(date,mas.ExpenseDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(date,mas.ExpenseDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END


		IF(@FromDt IS   NULL AND @ToDt IS   NULL)
		BEGIN
		    SET @params=@params+ '   '
		END
		 
    END
	
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND mas.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	END

	
	    --SET @params3= @params3 + ' AND  ToRoleTypeId<>'+convert(nvarchar(max),@roleTypeIdd)+' '

 

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='  select distinct * from (
		SELECT   usr.RoleName, dgs.DesigName, RT.RoleType  WaitingForRole,(SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''ExpenseMy'')+CAST(mas.ExpenseClaimID as nvarchar(max))+''.jpg'' AS   ImageString, case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified''  when mas.ApprovalStatus=''2'' then ''Approved''  WHEN mas.ApprovalStatus=''3'' then ''Rejected''  else mas.ApprovalStatus end ApprovalStatusWeb,mas.EmpInfoId, us.UserRoleID, et.ExpenseTypeName TypeName,   emp.EmpName, emp.EmpMasterCode, ExpenseClaimID, mas.ExpenseTypeId,
        t.ExpenseTypeName,
       
       Amount,
       Remarks,
       
          FORMAT(ExpenseDate,''dd MMM yyyy hh:mm tt'') ExpenseDate,
       
       mas.ApprovalStatus,
       
       
       tblExpanseApprovalLog.ExpanseApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblExpanseApprovalLog.TableId,
       tblExpanseApprovalLog.Status,
       Comments,
       Type,
       Step,
       0 GroupId,
      0 RegionId,
      0 AreaId,
       0 TerritoryId,
       
       tblExpanseApprovalLog.RoleTypeId,ToRoleTypeId,
       
       
 
	    
                                  
                               ''''  TerritoryName,
                             ''''    TerritoryCode,
                              ''''   AreaCode,
                               ''''  AreaName,
                               ''''  RegionCode,
                               ''''  RegionName,
                               ''''  GroupName,
                              0   MIOEmpId,
                               0  ASMEMPId,
                              0   RSMEMPId,
                                 0 NSMEMPId,LogMax.MaxStep
 
	   
	   
	   FROM dbo.tbl_ExpenseClaim mas
	     left join tbl_ExpenseTypeMaster t on mas.ExpenseTypeId=t.ExpenseTypeId
LEFT JOIN dbo.tblExpanseApprovalLog ON dbo.tblExpanseApprovalLog.TableId= mas.ExpenseClaimID
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblExpanseApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblExpanseApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = mas.EmpInfoId
 LEFT JOIN dbo.tblUser us ON emp.EmpInfoId=us.EmpInfoId
		  left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
		  LEFT JOIN dbo.tbl_ExpenseTypeMaster et ON et.ExpenseTypeId=mas.ExpenseTypeId
		  left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = emp.DesignationId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = emp.EmpInfoId
left join (select TableId,RoleTypeId from tblExpanseApprovalLog  with (nolock) where Step=1) as tblrole on mas.ExpenseClaimID=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
LEFT JOIN dbo.tblRoleType RT ON RT.RoleTypeId = tblExpanseApprovalLog.ToRoleTypeId
WHERE  Convert(date,mas.ExpenseDate) is not null '+@params+' AND  tblRoleType.RoleType<>'''+@Role+'''  AND Step=LogMax.MaxStep ' +@param+ @params3  +' ) tbl'

EXEC sys.sp_executesql @Q


    END





