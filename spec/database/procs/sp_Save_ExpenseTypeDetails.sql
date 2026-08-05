
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_ExpenseTypeDetails]
	-- Add the parameters for the stored procedure here
	@ExpenseTypDetailsId INT,
	@ExpenseTypeId INT,
    @FieldName NVARCHAR(MAX) = null ,
	@IsRequied BIT =null

AS
    BEGIN
	
        INSERT  INTO [dbo].[tbl_ExpenseTypeDetails]
                ( ExpenseTypeId ,                
                  FieldName ,
                  IsRequied 
               
	            )
        VALUES  ( @ExpenseTypeId ,                       
                  @FieldName,
                  @IsRequied             
	            )

SELECT SCOPE_IDENTITY()

END


