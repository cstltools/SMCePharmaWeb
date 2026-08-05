
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Check_ProductActiveorGift]
	-- Add the parameters for the stored procedure here
	@ProductId INT 
AS
BEGIN
 select * from tblProduct c where c.ProductId=@ProductId and c.IsActive=1 and  ProductGroupId=3
	 
END


