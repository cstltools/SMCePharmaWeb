
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_product_ByCode]
	-- Add the parameters for the stored procedure here
@Parameter NVARCHAR(50)
AS
BEGIN
	
	Select p.ProductId, p.ProductName, p.ProductCode,  UP.UnitPrice from tblProduct p
	LEFT JOIN tblUnitPrice UP ON UP.ProductId = p.ProductId
	where UP.IsActive = 1 And (p.ProductCode = @Parameter or p.ProductName=@Parameter)

END


