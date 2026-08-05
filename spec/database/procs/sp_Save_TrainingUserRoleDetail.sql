-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_TrainingUserRoleDetail]
	-- Add the parameters for the stored procedure here

	@UserRoleID INT,
	@TrainningId INT

AS
BEGIN
	
	INSERT INTO [dbo].tblTrainingUserRoleDetail
           (TrainningId
           ,UserRoleID)
     VALUES
           (@TrainningId
           ,@UserRoleID)

		   DELETE FROM dbo.tblTraining_Employee WHERE MasterId=@TrainningId

	INSERT INTO dbo.tblTraining_Employee
	(
	    EmployeeId,
	    IsAppCheck,
	    MasterId,
	    Server_SeenDate,
	    Apps_SeenDate
	)
	
	
	SELECT EmpInfoId,'1',@TrainningId,GETDATE(),GETDATE() FROM dbo.tblUser 
	WHERE UserRoleID=@UserRoleID AND EmpInfoId NOT IN (SELECT EmployeeId FROM dbo.tblTraining_Employee WHERE MasterId=@TrainningId)
END

