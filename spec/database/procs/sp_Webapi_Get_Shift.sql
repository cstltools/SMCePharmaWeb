CREATE PROCEDURE [dbo].[sp_Webapi_Get_Shift]
	-- Add the parameters for the stored procedure here
@empId INT = NULL
AS
BEGIN
		
		SELECT ShiftId ,
               ShiftText 
			    FROM dbo.tbl_Shift WHERE IsActive = 1
		 

END
