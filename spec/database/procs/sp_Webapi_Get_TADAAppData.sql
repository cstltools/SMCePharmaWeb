-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TADAAppData]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt NVARCHAR(MAX) =NULL,
	@ToDt NVARCHAR(MAX)=NULL,
	@Month NVARCHAR(MAX)=NULL,
	@Year NVARCHAR(MAX)=NULL,
	@EmpId INT =NULL
AS
    BEGIN
	
	DECLARE @params NVARCHAR(max)=' '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=@params+' and tbl_TadaClaimMaster.ApprovalStatus ='''+@AppStatus+''''
		--IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		--BEGIN
		--    SET @params=@params+ ' AND Convert(Date,tblTADAApprovalLog.EntryDateApp)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		--END
		--IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		--BEGIN
		--    SET @params=@params+ ' AND Convert(Date,tblTADAApprovalLog.EntryDateApp) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		--END
	END
	--ELSE
 --   BEGIN
 --       IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
	--	BEGIN
	--	    SET @params=@params+ ' AND Convert(Date,tbl_TadaClaimMaster.TADADate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
	--	END
	--	IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
	--	BEGIN
	--	    SET @params=@params+ ' AND Convert(Date,tbl_TadaClaimMaster.TADADate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
	--	END
 --   END
	
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND tbl_TadaClaimMaster.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	END


	 IF(@Month IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND Month(Convert(Date,tbl_TadaClaimMaster.TADADate))='''+CAST(@Month AS NVARCHAR(max))+''''
		END

		IF(@Year IS NOT NULL )
		BEGIN
		    SET @params=@params+ ' AND Year(Convert(Date,tbl_TadaClaimMaster.TADADate))='''+CAST(@Year AS NVARCHAR(max))+''''
		END
		

		declare @ccMont int=0
		declare @ccyear int=0

		set @ccMont=month(getdate())
		set @ccyear=year(getdate())

		--if(@ccMont=@Month and @ccyear=@Year)
		--begin
		

		----SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,tbl_TadaClaimMaster.TADADate),CONVERT(DATE,GETDATE())))<=7  '
		--end
		 

	DECLARE @Q NVARCHAR(MAX)=''
	SET @Q='

	SELECT distinct
       
       tbl_TadaClaimMaster.EmpInfoId,
                  Remarks ,
       tbl_TadaClaimMaster.DAAmount,
       format(TadaDate,''dd MMM yyyy'') TadaDate,
       
       tbl_TadaClaimMaster.ApprovalStatus,
       
       
       tblTADAApprovalLog.TADAApprovalId ApprovalId ,
       Date,
       FromEmpId,
       ToEmpId,
       tblTADAApprovalLog.TableId,
       tblTADAApprovalLog.Status,
       Comments,
       Type,
       Step,
       0 GroupId,
       0 RegionId,
       0 AreaId,
       0 TerritoryId,
       
       tblTADAApprovalLog.RoleTypeId,isnull(tblTADAApprovalLog.ToRoleTypeId,0) ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
       tblEmpGeneralInfo.EmpName,
	   0 TerritoryId,
                                 0 AreaId,
                                 0 RegionId,
                                 0 GroupId,
                               0 TerritoryName,
                               0   TerritoryCode,
                                0  AreaCode,
                                0 AreaName,
                               0   RegionCode,
                                 0 RegionName,
                               0 GroupName,
                            MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep
	   ,(SELECT LTRIM(RTRIM(ImagePath+''\''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''TADA'')AS ImagePreName  FROM dbo.tbl_TadaClaimMaster  with (nolock) 

	   
LEFT JOIN dbo.tblTADAApprovalLog  with (nolock)  ON dbo.tblTADAApprovalLog.TableId=dbo.tbl_TadaClaimMaster.TadaID
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblTADAApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblTADAApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock)  ON tblEmpGeneralInfo.EmpInfoId = tbl_TadaClaimMaster.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock)  ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tbl_TadaClaimMaster.EmpInfoId
 left join (select TableId,RoleTypeId from tblTADAApprovalLog  with (nolock) where Step=1) as tblrole on tbl_TadaClaimMaster.TadaID=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE tbl_TadaClaimMaster.TadaID is not null '+@params+' AND  tblRoleType.RoleType<>'''+@Role+'''  AND Step=LogMax.MaxStep '+@param+' order by format(TadaDate,''dd MMM yyyy'') desc'

EXEC sys.sp_executesql @Q


    END





