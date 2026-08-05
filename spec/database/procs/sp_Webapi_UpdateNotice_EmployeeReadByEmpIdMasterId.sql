CREATE PROCEDURE [dbo].[sp_Webapi_UpdateNotice_EmployeeReadByEmpIdMasterId]
	-- Add the parameters for the stored procedure here
@id int,

@EmployeeId int,
@Apps_SeenDate datetime
AS
BEGIN
		
		UPDATE dbo.tblNotice_Employee SET IsAppCheck = 1, Server_SeenDate=GETDATE(), Apps_SeenDate=@Apps_SeenDate WHERE MasterId= @id and EmployeeId=@EmployeeId
		


END
