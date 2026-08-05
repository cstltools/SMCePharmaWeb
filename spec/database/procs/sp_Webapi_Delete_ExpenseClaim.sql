-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Delete_ExpenseClaim]
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
	
	DELETE FROM dbo.tbl_ExpenseClaim WHERE ExpenseClaimID = @id
	DELETE FROM dbo.tbl_ExpenseClaimDetails WHERE ExpenseClaimID =@id



END

