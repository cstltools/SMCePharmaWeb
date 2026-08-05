
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_ExpenseType]
	-- Add the parameters for the stored procedure here
    @ExpenseTypeId INT 
   
AS
    BEGIN

	Delete from tbl_ExpenseTypeDetails where ExpenseTypeId = @ExpenseTypeId

    Delete from tbl_ExpenseTypeMaster where ExpenseTypeId = @ExpenseTypeId

   
    END
