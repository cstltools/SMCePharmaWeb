create PROCEDURE [dbo].[sp_Webapi_Get_AllApprovalPendingInfo] 
	-- Add the parameters for the stored procedure here
	@pram nvarchar(max),
	@Role nvarchar(max)

AS
BEGIN
		
			DECLARE @Q NVARCHAR(MAX)=''

			--Doctor
	SET @Q='
		SELECT ''Team Doctor'' app_Title ,   cast(isnull(count(*),0) as nvarchar(max))   app_value , ''#0000ff''  app_Color
	    
	   FROM dbo.tblDoctorMaster DM  with (NOLOCK)  
	     
LEFT JOIN dbo.tblDoctorApprovalLog_New  with (NOLOCK)   ON dbo.tblDoctorApprovalLog_New.TableId=DM.DoctorId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblDoctorApprovalLog_New  with (NOLOCK)    GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblDoctorApprovalLog_New.TableId
left join tblUser on tblUser.UserId=DM.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo  with (NOLOCK)   ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (NOLOCK)   ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId

 Left Join dbo.tblDoctorDesignation dgs  with (NOLOCK)  ON dgs.DesignationId= DM.DesignationId
   Left Join dbo.tblDoctorProgramType pt  with (NOLOCK)  ON pt.ProgramTypeId= DM.ProgramType
    left join  tblMarket mr on DM.MarketId=mr.MarketId

	 left join (select TableId,RoleTypeId from tblDoctorApprovalLog_New  with (nolock) where Step=1) as tblrole on DM.DoctorId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE   CONVERT(DATE,DM.EntryDate) >= CONVERT(DATE,DATEADD(DAY, -7, GETDATE())) and    tblRoleType.RoleType<>'''+@Role+'''   AND Step=LogMax.MaxStep    and DM.ApprovalStatus not in (''2'',''3'') ' +@pram +'
having  isnull(count(*),0)>0


union all 

	SELECT ''Team Customer'' app_Title ,  cast(isnull(count(*),0) as nvarchar(max))  app_value   , ''#3cb371''  app_Color   FROM dbo.tblCustMaster mas  with (nolock)
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
where  CONVERT(DATE,mas.CreateDate) >= CONVERT(DATE,DATEADD(DAY, -7, GETDATE()))  and tblRoleType.RoleType<>'''+@Role+'''   AND Step=LogMax.MaxStep  and mas.ActionStatus not in (''2'',''3'') ' +@pram +'
having  isnull(count(*),0)>0





union all 

	SELECT ''Team Expense Claim'' app_Title ,  cast(isnull(count(*),0) as nvarchar(max))  app_value   , ''#3cb371''  app_Color   FROM dbo.tbl_ExpenseClaim  with (nolock)
	     left join tbl_ExpenseTypeMaster t  with (nolock) on tbl_ExpenseClaim.ExpenseTypeId=t.ExpenseTypeId
LEFT JOIN dbo.tblExpanseApprovalLog  with (nolock) ON dbo.tblExpanseApprovalLog.TableId=dbo.tbl_ExpenseClaim.ExpenseClaimID
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblExpanseApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblExpanseApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tbl_ExpenseClaim.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
left join (select TableId,RoleTypeId from tblExpanseApprovalLog  with (nolock) where Step=1) as tblrole on tbl_ExpenseClaim.ExpenseClaimID=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
 

WHERE  tbl_ExpenseClaim.ExpenseClaimID is not null
and     CONVERT(DATE,tbl_ExpenseClaim.EntryDate) >= CONVERT(DATE,DATEADD(DAY, -7, GETDATE()))  and tblRoleType.RoleType<>'''+@Role+'''   AND    Step=LogMax.MaxStep and tbl_ExpenseClaim.ApprovalStatus not in (''2'',''3'') ' +@pram +'
having  isnull(count(*),0)>0





union all 

	SELECT ''Team DCR'' app_Title ,  cast(isnull(count(*),0) as nvarchar(max))  app_value   , ''#3cb371''  app_Color     FROM dbo.tbl_DCRInfo   with (nolock)
	        inner join tblDoctorMaster doc  with (nolock) on tbl_DCRInfo.DoctorId=Doc.DoctorId
LEFT JOIN dbo.tblDCRApprovalLog   with (nolock) ON dbo.tblDCRApprovalLog.TableId=dbo.tbl_DCRInfo.DcrId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblDCRApprovalLog   with (nolock)  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblDCRApprovalLog.TableId
left join tblUser   with (nolock) on tblUser.UserId=tbl_DCRInfo.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo   with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
 
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo   with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId

left join (select TableId,RoleTypeId from tblDCRApprovalLog  with (nolock) where Step=1) as tblrole on tbl_DCRInfo.DcrId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE  tbl_DCRInfo.DcrId is not null 
AND    CONVERT(DATE,tbl_DCRInfo.EntryDate) >= CONVERT(DATE,DATEADD(DAY, -7, GETDATE()))  and  tblRoleType.RoleType<>'''+@Role+'''   AND       Step=LogMax.MaxStep and tbl_DCRInfo.ApprovalStatus not in (''2'',''3'') ' +@pram +'
having  isnull(count(*),0)>0






union all 

	SELECT ''Team Prescription'' app_Title ,  cast(isnull(count(*),0) as nvarchar(max))  app_value   , ''#3cb371''  app_Color     FROM dbo.tbl_PrescriptionMaster with (nolock)
	     inner join tblDoctorMaster doc  with (nolock) on tbl_PrescriptionMaster.DoctorId=Doc.DoctorId
LEFT JOIN dbo.tblPrescriptionApprovalLog  with (nolock) ON dbo.tblPrescriptionApprovalLog.TableId=dbo.tbl_PrescriptionMaster.PrescriptionId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblPrescriptionApprovalLog  with (nolock)  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblPrescriptionApprovalLog.TableId
left join tblUser  with (nolock) on tblUser.UserId=tbl_PrescriptionMaster.EntryBy
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
left join (select TableId,RoleTypeId from tblPrescriptionApprovalLog  with (nolock) where Step=1) as tblrole on tbl_PrescriptionMaster.PrescriptionId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE   CONVERT(DATE,tbl_PrescriptionMaster.EntryDate) >= CONVERT(DATE,DATEADD(DAY, -7, GETDATE()))  and  tbl_PrescriptionMaster.PrescriptionId is not null
AND     tblRoleType.RoleType<>'''+@Role+'''   AND       Step=LogMax.MaxStep and tbl_PrescriptionMaster.ApprovalStatus not in (''2'',''3'') ' +@pram +'
having  isnull(count(*),0)>0





union all 

	SELECT ''Team Leave'' app_Title ,  cast(isnull(count(*),0) as nvarchar(max))  app_value   , ''#3cb371''  app_Color       FROM dbo.Employee_LeaveApplications  with (nolock)

	     INNER JOIN dbo.Employee_YearlyLeaveBalance B   with (nolock) ON B.LeaveBalanceId = Employee_LeaveApplications.LeaveBalanceId
		 INNER JOIN dbo.tblLeaveConType C  with (nolock) ON C.LeaveConTypeId = B.LeaveTypeId
               
LEFT JOIN dbo.tblLeaveApprovalLog  with (nolock) ON dbo.tblLeaveApprovalLog.TableId=dbo.Employee_LeaveApplications.LeaveApplicationId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblLeaveApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblLeaveApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = Employee_LeaveApplications.EmployeeId
 left JOIN dbo.tblUser us ON us.EmpInfoId = emp.EmpInfoId
 
left JOIN dbo.tbl_UserRoleInfo usr  with (nolock) ON usr.UserRoleID = us.UserRoleID
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = emp.EmpInfoId
left join (select TableId,RoleTypeId from tblLeaveApprovalLog  with (nolock) where Step=1) as tblrole on Employee_LeaveApplications.LeaveApplicationId=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId

WHERE    CONVERT(DATE,Employee_LeaveApplications.EntryDate) >= CONVERT(DATE,DATEADD(DAY, -7, GETDATE()))  and  Employee_LeaveApplications.LeaveApplicationId is not null
AND     tblRoleType.RoleType<>'''+@Role+'''   AND       Step=LogMax.MaxStep and Employee_LeaveApplications.ApprovalStatus not in (''2'',''3'') ' +@pram +'
having  isnull(count(*),0)>0





union all 

	SELECT ''Team Order'' app_Title ,  cast(isnull(count(*),0) as nvarchar(max))  app_value   , ''#3cb371''  app_Color         FROM dbo.tblOrder mas  with (nolock)
	 
  
LEFT JOIN dbo.tblOrderApprovalLog   with (nolock) ON dbo.tblOrderApprovalLog.TableId=mas.OrderId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblOrderApprovalLog  with (nolock)  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblOrderApprovalLog.TableId
left join tblUser on tblUser.UserId=mas.EntryBy
left JOIN dbo.tbl_UserRoleInfo usr  with (nolock) ON usr.UserRoleID = tblUser.UserRoleID
left join (select TableId,RoleTypeId from tblOrderApprovalLog  with (nolock) where Step=1) as tblrole on mas.OrderId=tblrole.TableId
left join tblMarket mr  with (nolock) on mr.MarketId=mas.MarketId
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE    CONVERT(DATE,mas.EntryDate) >= CONVERT(DATE,DATEADD(DAY, -7, GETDATE()))  and mas.OrderId is not null 
AND     tblRoleType.RoleType<>'''+@Role+'''   AND       Step=LogMax.MaxStep and mas.ActionStatus not in (''2'',''3'') ' +@pram +'
having  isnull(count(*),0)>0






union all 

	SELECT ''Team DA'' app_Title ,  cast(isnull(count(*),0) as nvarchar(max))  app_value   , ''#3cb371''  app_Color         FROM dbo.tbl_TadaClaimMaster  with (nolock) 

	   
LEFT JOIN dbo.tblTADAApprovalLog  with (nolock)  ON dbo.tblTADAApprovalLog.TableId=dbo.tbl_TadaClaimMaster.TadaID
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblTADAApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblTADAApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock)  ON tblEmpGeneralInfo.EmpInfoId = tbl_TadaClaimMaster.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock)  ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tbl_TadaClaimMaster.EmpInfoId
 left join (select TableId,RoleTypeId from tblTADAApprovalLog  with (nolock) where Step=1) as tblrole on tbl_TadaClaimMaster.TadaID=tblrole.TableId
left join tblRoleType  with (nolock) on tblRoleType.RoleTypeId=tblrole.RoleTypeId
WHERE tbl_TadaClaimMaster.TadaID is not null and CONVERT(DATE,tbl_TadaClaimMaster.EntryDate) >= CONVERT(DATE,DATEADD(DAY, -7, GETDATE())) 
AND     tblRoleType.RoleType<>'''+@Role+'''   AND       Step=LogMax.MaxStep and tbl_TadaClaimMaster.ApprovalStatus not in (''2'',''3'') ' +@pram +'
having  isnull(count(*),0)>0
'



	   
	   EXEC sys.sp_executesql @Q

END