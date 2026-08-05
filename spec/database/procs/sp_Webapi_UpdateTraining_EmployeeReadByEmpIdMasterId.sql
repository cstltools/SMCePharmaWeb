create PROCEDURE [dbo].[sp_Webapi_UpdateTraining_EmployeeReadByEmpIdMasterId]
	-- Add the parameters for the stored procedure here
@id int,

@EmployeeId int
AS
BEGIN
		
		 

		UPDATE dbo.tblTraining_Employee SET IsAppCheck = 1, Server_SeenDate=GETDATE() WHERE MasterId= @id and EmployeeId=@EmployeeId
		


END
