
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_QuotedPriceDetail]
	-- Add the parameters for the stored procedure here
	@QuotedPriceMasterId INT,
    @ProductId int =Null ,
    @UnitPrice decimal(18,3) =Null ,
    @Vat decimal(18,3) =Null 
	 
AS
    BEGIN
	
      INSERT INTO [dbo].[tblQuotedPriceDetail]
           ([QuotedPriceMasterId]
           ,[ProductId]
           ,[UnitPrice]
           ,[Vat])
     VALUES
           (@QuotedPriceMasterId 
           ,@ProductId 
           ,@UnitPrice 
           ,@Vat)

 

END


