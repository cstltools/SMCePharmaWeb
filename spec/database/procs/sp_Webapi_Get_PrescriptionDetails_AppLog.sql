-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_PrescriptionDetails_AppLog]
	-- Add the parameters for the stored procedure here
	@id INT 
AS
BEGIN
	 
	SELECT dtl.PrescriptionId   , pr.ProductCode +' : '+pr.ProductName  ProductName , dtl.ProductId
        
             FROM dbo.tbl_PrescriptionProductDetail dtl
			 left join tblProduct pr on pr.ProductId=dtl.ProductId

			  WHERE dtl.PrescriptionId = @id  
END

