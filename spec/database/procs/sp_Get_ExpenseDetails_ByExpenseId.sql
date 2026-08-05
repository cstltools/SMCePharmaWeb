
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_ExpenseDetails_ByExpenseId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN
	      
    Select dt.ExpenseTypDetailsId, dt.ExpenseTypeId, dt.FieldName, dt.IsRequied from tbl_ExpenseTypeDetails dt where dt.ExpenseTypeId= @id

    END


