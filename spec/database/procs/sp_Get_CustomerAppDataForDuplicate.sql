
CREATE PROCEDURE [dbo].[sp_Get_CustomerAppDataForDuplicate]
	-- Add the parameters for the stored procedure here

	@CustomerMasterId INT

AS
BEGIN
SELECT top 1 RT.RoleType WaitingForRole, mas.ActionStatus   ApprovalStatus, mas.CellNo,mas.Address,  case when mas.ActionStatus='0' then 'Pending'  when mas.ActionStatus='1' then 'Verified' when mas.ActionStatus='2' then 'Approved' when mas.ActionStatus='3' then 'Rejected'  else mas.ActionStatus end ApprovalStatusWeb, pt.ProgramTypeName,  mr.MarketName,  Chmist.CustomerType,DR. DistributionRouteName,  tblEmpGeneralInfo.EmpInfoId,mas.CustomerMasterId,
       CustomerName ,
                  CustomerCode ,
                  
          FORMAT(mas.CreateDate,'dd MMM yyyy') EntryDate,
       
       
       
       
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
                                 NSMEMPId,LogMax.MaxStep ,RT.RoleType AS WaitingRole,'' AS WatingEmployee
	   
	   
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
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblCustomerApprovalLog.RoleTypeId
LEFT JOIN dbo.tblRoleType RT  with (nolock) ON RT.RoleTypeId = tblCustomerApprovalLog.ToRoleTypeId

WHERE  mas.CustomerMasterId=@CustomerMasterId

order by tblCustomerApprovalLog.CustomerApprovalId desc
end