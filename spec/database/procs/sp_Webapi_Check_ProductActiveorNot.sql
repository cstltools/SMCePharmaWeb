
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Check_ProductActiveorNot]
	-- Add the parameters for the stored procedure here
	@ProductId INT 
AS
BEGIN
 select * from tblProduct c where c.ProductId=@ProductId and c.IsActive=1
	 
END


