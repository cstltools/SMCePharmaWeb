-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DoctorBrandDetail]
	-- Add the parameters for the stored procedure here
@masterId INT = NULL,
@itemName NVARCHAR(max) = NULL
AS
BEGIN


		DECLARE @dgId INT 


	SELECT   @dgId= ProductBrandId FROM dbo.tblProductSQ WHERE ProductSQName = @itemName

	IF(@dgId IS NOT NULL)
	BEGIN 
		INSERT INTO dbo.tblDoctorBrandDetail
		        ( DoctorId, BrandId )
		VALUES  ( @masterId,@dgId
		          )
	END




END

