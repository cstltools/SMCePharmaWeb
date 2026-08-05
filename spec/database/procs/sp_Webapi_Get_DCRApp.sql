
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DCRApp]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt DATETIME =NULL,
	@ToDt DATETIME =NULL,
	@EmpId INT =NULL,
	@GroupId NVARCHAR(MAX)= NULL,
@ZoneId  NVARCHAR(MAX)= NULL,
@AreaId  NVARCHAR(MAX)= NULL,
@TerritoryId   NVARCHAR(MAX)= NULL,
@providertype   NVARCHAR(MAX)= NULL,
@pharmatype   NVARCHAR(MAX)= NULL,
@doctortype   NVARCHAR(MAX)= NULL

AS
    BEGIN
	
	DECLARE @params NVARCHAR(max)='   '
	IF(@GroupId<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_DCRInfo.GroupId)='''+CAST(CONVERT(Int,@GroupId) AS NVARCHAR(max))+''''
		    
		END

		IF(@ZoneId<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_DCRInfo.RegionId)='''+CAST(CONVERT(Int,@ZoneId) AS NVARCHAR(max))+''''
		    
		END

		
		IF(@AreaId<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_DCRInfo.AreaId)='''+CAST(CONVERT(Int,@AreaId) AS NVARCHAR(max))+''''
		    
		END

			IF(@TerritoryId<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_DCRInfo.TerritoryId)='''+CAST(CONVERT(Int,@TerritoryId) AS NVARCHAR(max))+''''
		    
		END


		

			IF(@providertype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_DCRInfo.DoctorProgramypeId)='''+CAST(CONVERT(Int,@providertype) AS NVARCHAR(max))+''''
		    
		END

			IF(@pharmatype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_DCRInfo.SmcTypeId_DCR)='''+CAST(CONVERT(Int,@pharmatype) AS NVARCHAR(max))+''''
		    
		END

			IF(@doctortype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,doc.Doctortypeid)='''+CAST(CONVERT(Int,@doctortype) AS NVARCHAR(max))+''''
		    
		END

	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=@params+' and tbl_DCRInfo.ApprovalStatus ='''+@AppStatus+''''
		  IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND  CONVERT(DATE,tbl_DCRInfo.EntryDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND  CONVERT(DATE,tbl_DCRInfo.EntryDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND  CONVERT(DATE,tbl_DCRInfo.EntryDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND  CONVERT(DATE,tbl_DCRInfo.EntryDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
    END

	IF(@FromDt IS  NULL AND @ToDt IS NULL)

	begin
	 SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,tbl_DCRInfo.EntryDate),CONVERT(DATE,GETDATE())))<=7  '
	end
	
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params
	END

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='

	SELECT   tblEmpGeneralInfo.EmpInfoId,tbl_DCRInfo.DcrId,
       DcrDate ,
                  
          FORMAT(tbl_DCRInfo.EntryDate,''dd MMM yyyy hh:mm tt'') EntryDate,
       
       tbl_DCRInfo.ApprovalStatus,
       
       
       tblDCRApprovalLog.DCRApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblDCRApprovalLog.TableId,
       tblDCRApprovalLog.Status,
       Comments,
       Type,
       Step,
       tblDCRApprovalLog.GroupId,
       tblDCRApprovalLog.RegionId,
       tblDCRApprovalLog.AreaId,
       tblDCRApprovalLog.TerritoryId,
       
       tblDCRApprovalLog.RoleTypeId,ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
    tblEmpGeneralInfo.EmpMasterCode+'' - ''+   tblEmpGeneralInfo.EmpName EmpName,
	   View_Webapi_EmployeeFieldForceInfo.TerritoryId,
                                 View_Webapi_EmployeeFieldForceInfo.AreaId,
                                 View_Webapi_EmployeeFieldForceInfo.RegionId,
                                 View_Webapi_EmployeeFieldForceInfo.GroupId,
                                 tbl_DCRInfo.TerritoryName,
                                 TerritoryCode,
                                 AreaCode,
                                 tbl_DCRInfo.AreaName,
                                 RegionCode,
                                 tbl_DCRInfo.RegionName,
                                 tbl_DCRInfo.GroupName,
                                 MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep 
								 ,tblRoleType.RoleType AS WaitingRole,'''' AS WatingEmployee
	   
	   
	   FROM dbo.tbl_DCRInfo   with (nolock)
	        inner join tblDoctorMaster doc  with (nolock) on tbl_DCRInfo.DoctorId=Doc.DoctorId
LEFT JOIN dbo.tblDCRApprovalLog   with (nolock) ON dbo.tblDCRApprovalLog.TableId=dbo.tbl_DCRInfo.DcrId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblDCRApprovalLog   with (nolock)  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblDCRApprovalLog.TableId
left join tblUser   with (nolock) on tblUser.UserId=tbl_DCRInfo.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo   with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
 
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo   with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId

left join (select TableId,RoleTypeId from tblDCRApprovalLog  with (nolock) where Step=1) as tblrole on tbl_DCRInfo.DcrId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE  tbl_DCRInfo.DcrId is not null  '+@params+'   AND  tblRoleType.RoleType<>'''+@Role+''' AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END






