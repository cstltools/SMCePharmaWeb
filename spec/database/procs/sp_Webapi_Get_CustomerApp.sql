
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CustomerApp]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt DATETIME =NULL,
	@ToDt DATETIME =NULL,
	@EmpId INT =NULL,
	@TerritoryId INT =NULL,
	@CustomerTypeId INT =NULL,
	@ProgramTypeId INT =NULL,
	@SMCTypeId INT =NULL




AS
    BEGIN
	
	DECLARE @params NVARCHAR(max)=' tblCustomerApprovalLog.Status NOT IN (''Accepted'',''Reject'') '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' mas.ActionStatus='''+@AppStatus+''''
		IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND convert(Date,tblCustomerApprovalLog.EntryDateApp)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND convert(Date,tblCustomerApprovalLog.EntryDateApp) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND  convert(Date, mas.CreateDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND  convert(Date, mas.CreateDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END


		
		IF(@FromDt IS   NULL AND @ToDt IS   NULL)
		BEGIN
		    SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,mas.CreateDate),CONVERT(DATE,GETDATE())))<=7  '
		END
		else

		begin
		    SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,mas.CreateDate),CONVERT(DATE,GETDATE())))<=7  '
		
		end

		IF(@TerritoryId <>'0'   )
		BEGIN
		    SET @params=@params+ ' AND  terry.TerritoryId='''+CAST(@TerritoryId AS NVARCHAR(max))+''''
		END


			IF(@CustomerTypeId <>'0'  )
		BEGIN
		    SET @params=@params+ ' AND  mas.CustomerTypeId='''+CAST(@CustomerTypeId AS NVARCHAR(max))+''''
		END


			IF(@ProgramTypeId <>'0' or @ProgramTypeId <>'' )
		BEGIN
		    SET @params=@params+ ' AND  mas.ProgramTypeId='''+CAST(@ProgramTypeId AS NVARCHAR(max))+''''
		END

			IF(@SMCTypeId <>'0' or @SMCTypeId <>'' )
		BEGIN
		    SET @params=@params+ ' AND  mas.SMCTypeId='''+CAST(@SMCTypeId AS NVARCHAR(max))+''''
		END

    END
	
	--IF(@EmpId IS NOT NULL)
	--BEGIN
	--    SET @params= @params + ' AND tblCustMaster.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	--END

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='
	SELECT mas.ActionStatus   ApprovalStatus, mas.CellNo,mas.Address,  case when mas.ActionStatus=''0'' then ''Pending''  when mas.ActionStatus=''1'' then ''Verified'' when mas.ActionStatus=''2'' then ''Approved'' when mas.ActionStatus=''3'' then ''Rejected''  else mas.ActionStatus end ApprovalStatusWeb, pt.ProgramTypeName,  mr.MarketName,  Chmist.CustomerType,DR. DistributionRouteName,  tblEmpGeneralInfo.EmpInfoId,mas.CustomerMasterId,
       CustomerName ,
                  CustomerCode ,
                  
          FORMAT(mas.CreateDate,''dd MMM yyyy'') EntryDate,
       
       
       
       
       tblCustomerApprovalLog.CustomerApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblCustomerApprovalLog.TableId,
       tblCustomerApprovalLog.Status,
       Comments,
       tblCustomerApprovalLog.Type,
       Step,
       tblCustomerApprovalLog.GroupId,
       tblCustomerApprovalLog.RegionId,
       tblCustomerApprovalLog.AreaId,
       tblCustomerApprovalLog.TerritoryId,
       
       tblCustomerApprovalLog.RoleTypeId,ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
       tblEmpGeneralInfo.EmpName,
	   View_Webapi_EmployeeFieldForceInfo.TerritoryId,
                                 View_Webapi_EmployeeFieldForceInfo.AreaId,
                                 View_Webapi_EmployeeFieldForceInfo.RegionId,
                                 View_Webapi_EmployeeFieldForceInfo.GroupId,
                                View_Webapi_EmployeeFieldForceInfo.TerritoryName,
                                 View_Webapi_EmployeeFieldForceInfo.TerritoryCode,
                                  View_Webapi_EmployeeFieldForceInfo.AreaCode,
                                 AreaName,
                                  View_Webapi_EmployeeFieldForceInfo.RegionCode,
                                 RegionName,
                                 GroupName,
                                 MIOEmpId,
                                 ASMEMPId,
                                 RSMEMPId,
                                 NSMEMPId,LogMax.MaxStep ,RT.RoleType AS WaitingRole,'''' AS WatingEmployee
	   
	   
	   FROM dbo.tblCustMaster mas  with (nolock)
	     LEFT JOIN dbo.tblCustomerType Chmist   WITH (NOLOCK)  ON Chmist.CustomerTypeId = mas.CustomerTypeId
 LEFT JOIN dbo.tblProgramType pt  WITH (NOLOCK)  ON pt.ProgramTypeId = mas.ProgramTypeId
 LEFT JOIN dbo.tblDistributionRoute DR  WITH (NOLOCK)  ON DR.DistributionRouteId = mas.DistributionRouteId

  left join  tblMarket mr  with (nolock) on mas.MarketId=mr.MarketId


   
    left JOIN dbo.tblSubTerritory tr  with (nolock) ON tr.SubTerritoryId = mr.SubTerritoryId
        left JOIN dbo.tblTerritory terry  with (nolock) ON terry.TerritoryId = tr.TerritoryId

        left JOIN tblRouteInformationMarketDetail DCdtl  with (nolock) on mas.MarketId=DCdtl.MarketId
		left join tblRouteInformationMaster dcMas  with (nolock) on dcMas.RouteInformationMasterId=DCdtl.RouteInformationMasterId



LEFT JOIN dbo.tblCustomerApprovalLog  with (nolock) ON dbo.tblCustomerApprovalLog.TableId=mas.CustomerMasterId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblCustomerApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblCustomerApprovalLog.TableId
left join tblUser  with (nolock) on tblUser.UserId=mas.CreateBy
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
 left join (select TableId,RoleTypeId from tblCustomerApprovalLog  with (nolock) where Step=1) as tblrole on mas.CustomerMasterId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
LEFT JOIN dbo.tblRoleType RT  with (nolock) ON RT.RoleTypeId = tblCustomerApprovalLog.ToRoleTypeId
WHERE   '+@params+' AND  tblRoleType.RoleType<>'''+@Role+'''   AND Step=LogMax.MaxStep and mas.ActionStatus!=''3''  '+@param  +'  ORDER BY mas.CreateDate DESC '

EXEC sys.sp_executesql @Q


    END

