-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_NoticeUserRoleDetail]
	-- Add the parameters for the stored procedure here

	@UserRoleID INT,
	@NoticeId INT

AS
BEGIN
	
	INSERT INTO [dbo].tblNoticeUserRoleDetail
           (NoticeId
           ,UserRoleID)
     VALUES
           (@NoticeId
           ,@UserRoleID)


	--DELETE FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId

	INSERT INTO dbo.tblNotice_Employee
	(
	    EmployeeId,
	    IsAppCheck,
	    MasterId
	     
	    
	)
	SELECT EmpInfoId,'0',@NoticeId FROM dbo.tblUser 
	WHERE UserRoleID=@UserRoleID AND EmpInfoId NOT IN (SELECT EmployeeId FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId)
END

