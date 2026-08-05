
CREATE PROCEDURE [dbo].[sp_Get_CustomerApp]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt DATETIME =NULL,
	@ToDt DATETIME =NULL,
	@EmpId INT =NULL,
	@TerritoryId INT =NULL

AS
    BEGIN
	
	DECLARE @params NVARCHAR(max)=' mas.ActionStatus NOT IN (''3'',''2'') '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' tblCustomerApprovalLog.Status IN ('''+@AppStatus+''')'
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


		
	--		IF(@FromDt IS  NULL AND @ToDt IS NULL)

	--begin
	--	if(@Role ='AM' and @Role='DZSM' )
	--	begin
	-- SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,mas.CreateDate),CONVERT(DATE,GETDATE())))<=7  '
	--end
	--end

		IF(@TerritoryId IS not  NULL )
		BEGIN
		    SET @params=@params+ ' AND  View_Webapi_EmployeeFieldForceInfo.TerritoryId='''+CAST(@TerritoryId AS NVARCHAR(max))+''''
		END

    END
	
	--IF(@EmpId IS NOT NULL)
	--BEGIN
	--    SET @params= @params + ' AND tblCustMaster.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	--END

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='
	SELECT  (SELECT dbo.fn_GetExistenceStatus(mas.CellNo) ) AS ExistenceStatus , sst.SMCType ,  RT.RoleType WaitingForRole, mas.ActionStatus   ApprovalStatus, mas.CellNo,mas.Address,  case when mas.ActionStatus=''0'' then ''Pending''  when mas.ActionStatus=''1'' then ''Verified'' when mas.ActionStatus=''2'' then ''Approved'' when mas.ActionStatus=''3'' then ''Rejected''  else mas.ActionStatus end ApprovalStatusWeb, pt.ProgramTypeName,  mr.MarketCode, mr.MarketName,  Chmist.CustomerType,DR. DistributionRouteName,  tblEmpGeneralInfo.EmpInfoId,mas.CustomerMasterId,
       CustomerName , CustomerCode ,    FORMAT(mas.CreateDate,''dd MMM yyyy hh:mm tt'') EntryDate, 
       tblCustomerApprovalLog.CustomerApprovalId,
       Date,  FromEmpId, ToEmpId, tblCustomerApprovalLog.TableId, tblCustomerApprovalLog.Status,
       Comments,
       tblCustomerApprovalLog.Type,
       Step,
       tblCustomerApprovalLog.GroupId,
       tblCustomerApprovalLog.RegionId,
       tblCustomerApprovalLog.AreaId,
       tblCustomerApprovalLog.TerritoryId,
       
       tblCustomerApprovalLog.RoleTypeId,ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode +'' : ''+ tblEmpGeneralInfo.EmpName EmpMasterCode,
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
                                 NSMEMPId,LogMax.MaxStep ,RT.RoleType AS WaitingRole,'''' AS WatingEmployee  FROM dbo.tblCustMaster mas  with (nolock)
	     LEFT JOIN dbo.tblCustomerType Chmist   WITH (NOLOCK)  ON Chmist.CustomerTypeId = mas.CustomerTypeId
 LEFT JOIN dbo.tblProgramType pt  WITH (NOLOCK)  ON pt.ProgramTypeId = mas.ProgramTypeId
 LEFT JOIN dbo.tblDistributionRoute DR  WITH (NOLOCK)  ON DR.DistributionRouteId = mas.DistributionRouteId
 left join  tblMarket mr  with (nolock) on mas.MarketId=mr.MarketId
  left JOIN dbo.tblSubTerritory tr  with (nolock) ON tr.SubTerritoryId = mr.SubTerritoryId
        left JOIN dbo.tblTerritory terry  with (nolock) ON terry.TerritoryId = tr.TerritoryId
        left JOIN dbo.tblSMCType sst  with (nolock) ON sst.SMCTypeId = mas.SMCTypeId
 left JOIN tblRouteInformationMarketDetail DCdtl  with (nolock) on mas.MarketId=DCdtl.MarketId
		left join tblRouteInformationMaster dcMas  with (nolock) on dcMas.RouteInformationMasterId=DCdtl.RouteInformationMasterId 
LEFT JOIN dbo.tblCustomerApprovalLog  with (nolock) ON dbo.tblCustomerApprovalLog.TableId=mas.CustomerMasterId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblCustomerApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblCustomerApprovalLog.TableId
left join tblUser  with (nolock) on tblUser.UserId=mas.CreateBy
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblCustomerApprovalLog.RoleTypeId
LEFT JOIN dbo.tblRoleType RT  with (nolock) ON RT.RoleTypeId = tblCustomerApprovalLog.ToRoleTypeId

WHERE   '+@params+' AND  tblRoleType.RoleType<>'''+@Role+'''   AND Step=LogMax.MaxStep and mas.ActionStatus!=''3''  '+@param  +'  ORDER BY mas.CreateDate DESC '

EXEC sys.sp_executesql @Q


    END
