CREATE PROCEDURE [dbo].[sp_CS_GetExpenseType_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT * FROM dbo.tbl_ExpenseTypeMaster WHERE IsActive = 1
END
