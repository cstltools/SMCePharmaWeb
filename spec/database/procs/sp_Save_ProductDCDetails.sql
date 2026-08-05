-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_ProductDCDetails]
	-- Add the parameters for the stored procedure here

	@ProductId INT,
	@ComUnitId INT

AS
BEGIN
	
	INSERT INTO [dbo].tblProductDCDetails
           (ProductId
           ,ComUnitId)
     VALUES
           (@ProductId
           ,@ComUnitId)
END

