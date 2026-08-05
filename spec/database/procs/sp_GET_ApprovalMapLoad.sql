

 CREATE PROCEDURE [dbo].[sp_GET_ApprovalMapLoad]
	-- Add the parameters for the stored procedure here
   @FromRoleId NVARCHAR(MAX) NULL,
   @MenuId NVARCHAR(MAX) NULL

AS
    BEGIN

	 SELECT ToRoleId,[Order],FromRoleId,tblApprovalMapMaster.ApprovalMapMasterId,RoleTypeId,tblRoleType.DisplayName RoleType FROM dbo.tblApprovalMapMaster
	 LEFT JOIN dbo.tblApprovalMapDetail ON tblApprovalMapDetail.ApprovalMapMasterId = tblApprovalMapMaster.ApprovalMapMasterId
	 left join tblRoleType on tblApprovalMapDetail.ToRoleId=tblRoleType.RoleTypeId
	 WHERE MenuId=@MenuId AND FromRoleId=@FromRoleId
      
    END


