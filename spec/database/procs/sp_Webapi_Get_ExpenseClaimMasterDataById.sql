-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ExpenseClaimMasterDataById]
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
		
		SELECT * FROM dbo.tbl_ExpenseClaim WHERE ExpenseClaimID = @id


END

