
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_ExpenseTypeDetails]
	-- Add the parameters for the stored procedure here
    @ExpenseTypDetailsId INT,
	@ExpenseTypeId INT,
    @FieldName NVARCHAR(MAX) = null ,
	@IsRequied BIT =null
AS
    BEGIN
        UPDATE  dbo.[tbl_ExpenseTypeDetails]
        SET     
		        ExpenseTypeId =@ExpenseTypeId,                
                  FieldName =@FieldName,
                  IsRequied =@IsRequied                      
        WHERE    ExpenseTypDetailsId = @ExpenseTypDetailsId
		 
    END


