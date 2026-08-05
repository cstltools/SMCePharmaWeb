
create PROCEDURE [dbo].[sp_Get_BrandName_All]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	
SELECT  A.ProductBrandId ,   A.ProductSQName 
FROM    dbo.tblProductSQ A with (nolock)
       
     order by  A.ProductSQName asc 

END
