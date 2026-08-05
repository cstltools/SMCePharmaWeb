
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_DoctorBrandByDoctorId]
	-- Add the parameters for the stored procedure here
	@DoctorId int
AS
BEGIN 

select mas.DoctorId DoctorId, mas.BrandId BrandId, pr.ProductSQName BrandName FROM dbo.tblDoctorBrandDetail mas WITH (NOLOCK)

		LEFT JOIN dbo.tblProductSQ pr  WITH (NOLOCK) ON mas.BrandId=pr.ProductBrandId 

	 

where mas.DoctorId=@DoctorId
END





