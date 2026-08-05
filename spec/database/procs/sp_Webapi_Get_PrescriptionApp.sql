
CREATE PROCEDURE [dbo].[sp_Webapi_Get_PrescriptionApp]
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

	IF(@GroupId<>0  )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_PrescriptionMaster.GroupId)='''+CAST(CONVERT(Int,@GroupId) AS NVARCHAR(max))+''''
		    
		END

		IF(@ZoneId<>0   )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_PrescriptionMaster.RegionId)='''+CAST(CONVERT(Int,@ZoneId) AS NVARCHAR(max))+''''
		    
		END

		
		IF(@AreaId<>0  )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_PrescriptionMaster.AreaId)='''+CAST(CONVERT(Int,@AreaId) AS NVARCHAR(max))+''''
		    
		END

			IF(@TerritoryId<>0  )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_PrescriptionMaster.TerritoryId)='''+CAST(CONVERT(Int,@TerritoryId) AS NVARCHAR(max))+''''
		    
		END


			IF(@providertype<>0   )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_PrescriptionMaster.DoctorProgramypeId)='''+CAST(CONVERT(Int,@providertype) AS NVARCHAR(max))+''''
		    
		END

			IF(@pharmatype<>0  )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tbl_PrescriptionMaster.SmcTypeId_RX)='''+CAST(CONVERT(Int,@pharmatype) AS NVARCHAR(max))+''''
		    
		END

			IF(@doctortype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,doc.Doctortypeid)='''+CAST(CONVERT(Int,@doctortype) AS NVARCHAR(max))+''''
		    
		END

	IF(@AppStatus IS NOT NULL)
	BEGIN
	SET @params=@params+' and tbl_PrescriptionMaster.ApprovalStatus ='''+@AppStatus+''''
	 
		IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND CONVERT(DATE,tbl_PrescriptionMaster.EntryDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND CONVERT(DATE,tbl_PrescriptionMaster.EntryDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND  CONVERT(DATE,tbl_PrescriptionMaster.EntryDate)  ='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND  CONVERT(DATE,tbl_PrescriptionMaster.EntryDate)  between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
    END
	
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params
	END


		IF(@FromDt IS  NULL AND @ToDt IS NULL)

	begin
	 SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,tbl_PrescriptionMaster.EntryDate),CONVERT(DATE,GETDATE())))<=7  '
	end

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='

	SELECT   tblEmpGeneralInfo.EmpInfoId,tbl_PrescriptionMaster.PrescriptionId,
       
                  
          FORMAT(tbl_PrescriptionMaster.EntryDate,''dd MMM yyyy'') EntryDate,
       
       tbl_PrescriptionMaster.ApprovalStatus,
       
       
       tblPrescriptionApprovalLog.PrescriptionApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblPrescriptionApprovalLog.TableId,
       tblPrescriptionApprovalLog.Status,
       Comments,
       Type,
       Step,
       tblPrescriptionApprovalLog.GroupId,
       tblPrescriptionApprovalLog.RegionId,
       tblPrescriptionApprovalLog.AreaId,
       tblPrescriptionApprovalLog.TerritoryId,
       
       tblPrescriptionApprovalLog.RoleTypeId,ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
     tblEmpGeneralInfo.EmpMasterCode+'' - ''+   tblEmpGeneralInfo.EmpName EmpName,
	   View_Webapi_EmployeeFieldForceInfo.TerritoryId,
                                 View_Webapi_EmployeeFieldForceInfo.AreaId,
                                 View_Webapi_EmployeeFieldForceInfo.RegionId,
                                 View_Webapi_EmployeeFieldForceInfo.GroupId,
                                 tbl_PrescriptionMaster.TerritoryName,
                                 TerritoryCode,
                                 AreaCode,
                                 tbl_PrescriptionMaster.AreaName,
                                 RegionCode,
                                 tbl_PrescriptionMaster.RegionName,
                                 tbl_PrescriptionMaster.GroupName,
                                 MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep 
	   
	   
	   FROM dbo.tbl_PrescriptionMaster with (nolock)
	     inner join tblDoctorMaster doc  with (nolock) on tbl_PrescriptionMaster.DoctorId=Doc.DoctorId
LEFT JOIN dbo.tblPrescriptionApprovalLog  with (nolock) ON dbo.tblPrescriptionApprovalLog.TableId=dbo.tbl_PrescriptionMaster.PrescriptionId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblPrescriptionApprovalLog  with (nolock)  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblPrescriptionApprovalLog.TableId
left join tblUser  with (nolock) on tblUser.UserId=tbl_PrescriptionMaster.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
left join (select TableId,RoleTypeId from tblPrescriptionApprovalLog  with (nolock) where Step=1) as tblrole on tbl_PrescriptionMaster.PrescriptionId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE tbl_PrescriptionMaster.PrescriptionId is not null '+@params+'  AND  tblRoleType.RoleType<>'''+@Role+''' AND Step=LogMax.MaxStep '+@param +' order by tbl_PrescriptionMaster.EntryDate desc'

EXEC sys.sp_executesql @Q


    END






