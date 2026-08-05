
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_ExpenseType]
	-- Add the parameters for the stored procedure here
	  @ExpenseTypeId INT = 0 ,
    @ExpenseTypeName NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tbl_ExpenseTypeMaster e WHERE e.ExpenseTypeName=@ExpenseTypeName AND    ExpenseTypeId NOT IN ( @ExpenseTypeId)

END


