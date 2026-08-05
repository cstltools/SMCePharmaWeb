
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_ProductPriceOld]
	-- Add the parameters for the stored procedure here
	@ProductId INT
AS
BEGIN
	

	SELECT * FROM dbo.tblUnitPrice WHERE ProductId=@ProductId AND IsActive=1

END


