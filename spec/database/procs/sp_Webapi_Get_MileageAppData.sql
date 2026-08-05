CREATE PROCEDURE [dbo].[sp_Webapi_Get_MileageAppData]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt NVARCHAR(MAX) =NULL,
	@ToDt NVARCHAR(MAX)=NULL,
	@EmpId INT =NULL,
	@Month NVARCHAR(MAX)=NULL,
	@Year NVARCHAR(MAX)=NULL
AS
    BEGIN
	
	DECLARE @params NVARCHAR(max)='  '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	   SET @params=@params+' and tbl_MileageClaim.ApprovalStatus ='''+@AppStatus+''''
		IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,tbl_MileageClaim.MileageDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,tbl_MileageClaim.MileageDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,tbl_MileageClaim.MileageDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,tbl_MileageClaim.MileageDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
    END
	

	IF(@Month IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND Month(Convert(Date,tbl_MileageClaim.MileageDate))='''+CAST(@Month AS NVARCHAR(max))+''''
		END

		IF(@Year IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND Year(Convert(Date,tbl_MileageClaim.MileageDate))='''+CAST(@Year AS NVARCHAR(max))+''''
		END

	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND tbl_MileageClaim.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	END

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='

	SELECT  case when tbl_MileageClaim.ApprovalStatus=''0'' then ''Pending''  when tbl_MileageClaim.ApprovalStatus=''1'' then ''Verified'' when tbl_MileageClaim.ApprovalStatus=''2'' then ''Approved'' when tbl_MileageClaim.ApprovalStatus=''3'' then ''Rejected''  else tbl_MileageClaim.ApprovalStatus end ApprovalStatus,  tbl_MileageClaim.Remarks, tbl_MileageClaim.MeterReading, MileageClaimId, mr.MarketName,  t.TransportName, tbl_MileageClaim.AllowedMileageInKM AllowedMilagePerKM,tbl_MileageClaim.MileageInKM , tbl_MileageClaim.AllowedMileageInKM*tbl_MileageClaim.MileageInKM MileageAmount,
       
       tbl_MileageClaim.EmpInfoId,
       
       
       format(MileageDate,''dd MMM yyyy'') MileageDate,
       
        
       
       
       tblMileageApprovalLog.MileageApprovalId ApprovalId ,
       Date,
       FromEmpId,
       ToEmpId,
       tblMileageApprovalLog.TableId,
       tblMileageApprovalLog.Status,
       Comments,
       Type,
       Step,
       tblMileageApprovalLog.GroupId,
       tblMileageApprovalLog.RegionId,
       tblMileageApprovalLog.AreaId,
       tblMileageApprovalLog.TerritoryId,
       
       tblMileageApprovalLog.RoleTypeId,isnull(ToRoleTypeId,0) ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
       tblEmpGeneralInfo.EmpName,
	   View_Webapi_EmployeeFieldForceInfo.TerritoryId,
                                 View_Webapi_EmployeeFieldForceInfo.AreaId,
                                 View_Webapi_EmployeeFieldForceInfo.RegionId,
                                 View_Webapi_EmployeeFieldForceInfo.GroupId,
                                 tbl_MileageClaim.TerritoryName,
                                 TerritoryCode,
                                 AreaCode,
                                 tbl_MileageClaim.AreaName,
                                 RegionCode,
                                 tbl_MileageClaim.RegionName,
                                 tbl_MileageClaim.GroupName,
                                 MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep,
	   (SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''MileageMy'')+CAST(tbl_MileageClaim.MileageClaimId as nvarchar(max))+''.jpg'' AS   ImageString  FROM dbo.tbl_MileageClaim

	   left join tbl_Transport t on tbl_MileageClaim.TransportId=t.TransportId
	      left join tblMarket mr on tbl_MileageClaim.MarketId=mr.MarketId
LEFT JOIN dbo.tblMileageApprovalLog ON dbo.tblMileageApprovalLog.TableId=dbo.tbl_MileageClaim.MileageClaimId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblMileageApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblMileageApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tbl_MileageClaim.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
 left join (select TableId,RoleTypeId from tblMileageApprovalLog  with (nolock) where Step=1) as tblrole on tbl_MileageClaim.MileageClaimId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE tbl_MileageClaim.MileageClaimId is not null '+@params+'  AND  tblRoleType.RoleType<>'''+@Role+''' AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END