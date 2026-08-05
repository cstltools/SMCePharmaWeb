

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ApprovalMapData]
	@MenuId INT

AS
BEGIN
    	 
   SELECT * FROM dbo.tblApprovalMapMaster
   LEFT JOIN dbo.tblApprovalMapDetail ON tblApprovalMapDetail.ApprovalMapMasterId = tblApprovalMapMaster.ApprovalMapMasterId
   WHERE MenuId=@MenuId

END


