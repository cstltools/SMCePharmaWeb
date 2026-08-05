


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_ApprovalMapMaster]

	
    @MenuId INT NULL,
	    @MenuName NVARCHAR(MAX) NULL,
	    @FromRoleId INT NULL

AS
BEGIN

	declare @CountData int=0
	select @CountData=count(*) from tblApprovalMapMaster where MenuId=@MenuId and FromRoleId=@FromRoleId
	IF(@CountData<1)
	BEGIN

	 
	INSERT INTO dbo.tblApprovalMapMaster
	(
	    MenuId,
	    MenuName,
	    FromRoleId
	)
	VALUES
	(   @MenuId,
	    @MenuName,
	    @FromRoleId
	    )
		declare @Id int
	SELECT SCOPE_IDENTITY()
	
	
	end
	else
	begin
	select ApprovalMapMasterId from  tblApprovalMapMaster where MenuId=@MenuId and FromRoleId=@FromRoleId
	delete from tblApprovalMapDetail where ApprovalMapMasterId in (select ApprovalMapMasterId from tblApprovalMapMaster where  MenuId=@MenuId and FromRoleId=@FromRoleId)
	end

END




