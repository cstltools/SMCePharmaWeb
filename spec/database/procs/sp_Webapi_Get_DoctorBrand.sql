-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorBrand] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		select MAX(MaxValue) as MaxValue, ProductBrandId, ProductSQName from tblProductSQ  with (nolock)

		group by ProductBrandId, ProductSQName

		order by  ProductSQName asc


END

