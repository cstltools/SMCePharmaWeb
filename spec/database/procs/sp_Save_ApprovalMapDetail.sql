


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_ApprovalMapDetail]

	
    @ApprovalMapMasterId INT NULL,
	    @ToRoleId INT NULL,
	    @Order INT NULL

AS
BEGIN

--DELETE FROM dbo.tblApprovalMapDetail WHERE ApprovalMapMasterId=@ApprovalMapMasterId AND ToRoleId=@ToRoleId


	INSERT INTO dbo.tblApprovalMapDetail
	(
	    ApprovalMapMasterId,
	    ToRoleId,
	    [Order]
	)
	VALUES
	(   @ApprovalMapMasterId,
	    @ToRoleId,
	    @Order
	    )

	SELECT SCOPE_IDENTITY()

END




