
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 create PROCEDURE [dbo].[sp_ExpenseTypeDtl]
	-- Add the parameters for the stored procedure here
    @ExpenseTypeId  INT  

AS
    BEGIN
         Delete from tbl_ExpenseTypeDetails where        ExpenseTypDetailsId = @ExpenseTypeId	 
    END


