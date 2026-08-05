
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CustomerPendingReject]
	-- Add the parameters for the stored procedure here
    @empid INT ,
    @ApprovalStatus nvarchar(max)
    
AS
    BEGIN
	

	--SELECT dbo.tblCustMaster.CustomerMasterId, CustomerName,(CASE WHEN ActionStatus='0' THEN 'Pending'  WHEN ActionStatus='2'  
	--THEN 'Approved'  WHEN ActionStatus='1'  
	--THEN 'Verified' WHEN ActionStatus='3' THEN 'Rejected' ELSE ActionStatus END)AS ActionStatus ,CellNo,tblMarket.MarketName, tblCustMaster.OwnerName, tblCustMaster.Address  , pt.ProgramTypeName,(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Customer')AS CustomerImagePreName,
	--RoleType AS WaitingRole,'' AS WatingEmployee
	
	--FROM tblCustMaster 
	--LEFT JOIN dbo.tblUser ON dbo.tblUser.UserId=dbo.tblCustMaster.CreateBy
	--left join tblMarket on tblCustMaster.MarketId=tblMarket.MarketId
	--left join dbo.tblProgramType pt on tblCustMaster.ProgramTypeId=pt.ProgramTypeId
	--LEFT JOIN dbo.tblCustomerApprovalLog ON dbo.tblCustomerApprovalLog.TableId=dbo.tblCustMaster.CustomerMasterId
	--LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblCustomerApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblCustMaster.CustomerMasterId
	--LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tblCustomerApprovalLog.ToRoleTypeId
	--WHERE tblCustMaster.ActionStatus=@ApprovalStatus  AND Step=LogMax.MaxStep
	-- AND EmpInfoId=@empid



	SELECT dbo.tblCustMaster.CustomerMasterId, dbo.tblCustMaster.CustomerName,(CASE WHEN dbo.tblCustMaster.ActionStatus='0' THEN 'Pending'  WHEN dbo.tblCustMaster.ActionStatus='2'  
	THEN 'Approved'  WHEN dbo.tblCustMaster.ActionStatus='1'  
	THEN 'Verified' WHEN dbo.tblCustMaster.ActionStatus='3' THEN 'Rejected' ELSE dbo.tblCustMaster.ActionStatus END)AS ActionStatus ,CV.CellNo,tblMarket.MarketName, tblCustMaster.OwnerName, tblCustMaster.Address  , pt.ProgramTypeName,(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock) WHERE ImageType='Customer')AS CustomerImagePreName,
	RoleType AS WaitingRole,'' AS WatingEmployee
	
	FROM tblCustMaster   with (nolock) 
	LEFT JOIN dbo.tblUser  with (nolock) ON dbo.tblUser.UserId=dbo.tblCustMaster.CreateBy
	left join tblMarket  with (nolock) on tblCustMaster.MarketId=tblMarket.MarketId
	left join dbo.tblProgramType  pt  with (nolock) on tblCustMaster.ProgramTypeId=pt.ProgramTypeId
	LEFT JOIN dbo.tblCustomerApprovalLog  with (nolock) ON dbo.tblCustomerApprovalLog.TableId=dbo.tblCustMaster.CustomerMasterId
	LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblCustomerApprovalLog  with (nolock) GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblCustMaster.CustomerMasterId
	LEFT JOIN dbo.tblRoleType  with (nolock) ON tblRoleType.RoleTypeId = tblCustomerApprovalLog.ToRoleTypeId
	LEFT JOIN dbo.View_CustomerMaster CV  with (nolock) ON CV.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId

	WHERE tblCustMaster.ActionStatus=@ApprovalStatus  AND Step=LogMax.MaxStep
	 ---AND EmpInfoId=@empid
	 AND (CV.NSMEmpInfoId=@empid OR CV.RSMEmpInfoId=@empid OR CV.ASMEmpInfoId=@empid OR CV.MIOEmpInfoId=@empid)

	 UNION ALL
	 SELECT dbo.tblCustMaster.CustomerMasterId, dbo.tblCustMaster.CustomerName,(CASE WHEN dbo.tblCustMaster.ActionStatus='0' THEN 'Pending'  WHEN dbo.tblCustMaster.ActionStatus='2'  
	THEN 'Approved'  WHEN dbo.tblCustMaster.ActionStatus='1'  
	THEN 'Verified' WHEN dbo.tblCustMaster.ActionStatus='3' THEN 'Rejected' ELSE dbo.tblCustMaster.ActionStatus END)AS ActionStatus ,CV.CellNo,tblMarket.MarketName, tblCustMaster.OwnerName, tblCustMaster.Address  , pt.ProgramTypeName,(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock) WHERE ImageType='Customer')AS CustomerImagePreName,
	'' AS WaitingRole,'' AS WatingEmployee
	
	FROM tblCustMaster  with (nolock)
	LEFT JOIN dbo.tblUser  with (nolock)  ON dbo.tblUser.UserId=dbo.tblCustMaster.CreateBy
	left join tblMarket  with (nolock) on tblCustMaster.MarketId=tblMarket.MarketId
	left join dbo.tblProgramType pt  with (nolock) on tblCustMaster.ProgramTypeId=pt.ProgramTypeId
	--LEFT JOIN dbo.tblCustomerApprovalLog ON dbo.tblCustomerApprovalLog.TableId=dbo.tblCustMaster.CustomerMasterId
	--LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblCustomerApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblCustMaster.CustomerMasterId
	--LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tblCustomerApprovalLog.ToRoleTypeId
	LEFT JOIN dbo.View_CustomerMaster CV  with (nolock) ON CV.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId

	WHERE 
	tblCustMaster.ActionStatus=@ApprovalStatus AND 
	-- Step=LogMax.MaxStep
	 ---AND EmpInfoId=@empid
	-- AND 
	 (CV.NSMEmpInfoId=@empid 
	 OR CV.RSMEmpInfoId=@empid 
	 OR CV.ASMEmpInfoId=@empid 
	 OR 
	 CV.MIOEmpInfoId=@empid)


	--select * from tblCustMaster


    END

