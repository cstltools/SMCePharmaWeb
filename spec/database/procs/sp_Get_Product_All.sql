-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Product_All]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
select 0 CheckValue, pro.ProductId, pro.ProductCode+' ; '+pro.ProductName  + case when pro.IsActive=1 then '' else ' (Inactive)' end  ProductName, pro.ProductCode, pro.Description, un.UnitPrice, '' Vat, '' DiscountPercent,  * from tblProduct pro with (nolock)
inner join tblUnitPrice un  with (nolock) on pro.ProductId=un.ProductId
where pro.IsActive=1 and un.IsActive=1   
END


