
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Delete_ProductDCDetails]
	-- Add the parameters for the stored procedure here
    @ProductId INT 
   
AS
    BEGIN

	Delete from tblProductDCDetails where ProductId = @ProductId
 
    END
