
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ExpanseClaimApp]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt NVARCHAR(MAX) =NULL,
	@ToDt NVARCHAR(MAX) =NULL,
	@EmpId INT =NULL
AS
    BEGIN
	

	

 DECLARE @params NVARCHAR(max)='   '
	 
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' and tbl_ExpenseClaim.ApprovalStatus ='''+@AppStatus+''''
		--IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		--BEGIN
		--    SET @params=@params+ ' AND Convert(date,tbl_ExpenseClaim.ExpenseDate)='''+@FromDt+''''
		--END
		IF(@FromDt is not null AND @ToDt  is not null)
		BEGIN
		    SET @params=@params+ ' AND Convert(date,tbl_ExpenseClaim.ExpenseDate) between '''+@FromDt+''' AND '''+@ToDt+''' '
		END
	END
	ELSE
    BEGIN
  --      IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		--BEGIN
		--    SET @params=@params+ ' AND Convert(date,tbl_ExpenseClaim.ExpenseDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		--END
		IF(@FromDt  is not null AND @ToDt  is not null)
		BEGIN
		    SET @params=@params+ ' AND Convert(date,tbl_ExpenseClaim.ExpenseDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END


		
    END

	IF(@FromDt  is   null AND @ToDt is   null )
		BEGIN
		    SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,dbo.tbl_ExpenseClaim.EntryDate),CONVERT(DATE,GETDATE())))<=7  '
		END
		 
	
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND tbl_ExpenseClaim.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	END

	
	    --SET @params3= @params3 + ' AND  ToRoleTypeId<>'+convert(nvarchar(max),@roleTypeIdd)+' '

 

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='

	SELECT ExpenseClaimID, tbl_ExpenseClaim.ExpenseTypeId,
        t.ExpenseTypeName,
       tbl_ExpenseClaim.EmpInfoId,
       Amount,
       Remarks,
       
          FORMAT(ExpenseDate,''dd MMM yyyy'') ExpenseDate,
       
       tbl_ExpenseClaim.ApprovalStatus,
       
       
       tblExpanseApprovalLog.ExpanseApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblExpanseApprovalLog.TableId,
       tblExpanseApprovalLog.Status,
       Comments,
       Type,
       Step,
       tblExpanseApprovalLog.GroupId,
       tblExpanseApprovalLog.RegionId,
       tblExpanseApprovalLog.AreaId,
       tblExpanseApprovalLog.TerritoryId,
       
       tblExpanseApprovalLog.RoleTypeId,isnull(ToRoleTypeId,0) ToRoleTypeId,
       
       
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
	   ,(SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''ExpenseMy'')+CAST(tbl_ExpenseClaim.ExpenseClaimID as nvarchar(max))+''.jpg'' AS   ImageString
	   
	   
	   FROM dbo.tbl_ExpenseClaim  with (nolock)
	     left join tbl_ExpenseTypeMaster t  with (nolock) on tbl_ExpenseClaim.ExpenseTypeId=t.ExpenseTypeId
LEFT JOIN dbo.tblExpanseApprovalLog  with (nolock) ON dbo.tblExpanseApprovalLog.TableId=dbo.tbl_ExpenseClaim.ExpenseClaimID
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblExpanseApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblExpanseApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tbl_ExpenseClaim.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
left join (select TableId,RoleTypeId from tblExpanseApprovalLog  with (nolock) where Step=1) as tblrole on tbl_ExpenseClaim.ExpenseClaimID=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
 

WHERE  tbl_ExpenseClaim.ExpenseClaimID is not null  '+@params+' AND  tblRoleType.RoleType<>'''+@Role+'''  AND Step=LogMax.MaxStep ' +@param +' order by tbl_ExpenseClaim.ExpenseDate desc'

EXEC sys.sp_executesql @Q


    END


