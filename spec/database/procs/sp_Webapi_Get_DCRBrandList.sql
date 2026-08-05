-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_DCRBrandList]
	-- Add the parameters for the stored procedure here
	@DcrId INT 
AS
BEGIN
	 
	SELECT  dtl.BrandId, brnd.ProductSQName BrandName
        
             FROM dbo.tbl_DcrBrandDetails dtl with (nolock)
			 left join tblProductSQ brnd on dtl.BrandId=brnd.ProductBrandId

			  WHERE dtl.DcrId = @DcrId
END

