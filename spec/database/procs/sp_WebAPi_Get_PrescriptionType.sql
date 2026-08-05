CREATE PROCEDURE [dbo].[sp_WebAPi_Get_PrescriptionType]
	-- Add the parameters for the stored procedure here
@empId int
AS
BEGIN
		
		SELECT * FROM dbo.tbl_PrescriptionType WHERE IsActive = 1

END
