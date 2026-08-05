-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_PresCripProductbyId]
	-- Add the parameters for the stored procedure here
	@id INT 
AS
BEGIN
	 
	SELECT dtl.ProductId   , pro.ProductCode +' : '+
           ProductName AS ProductName 
        
             FROM tbl_PrescriptionProductDetail dtl  with (nolock)
			 left join tblProduct pro  with (nolock) on pro.ProductId=dtl.ProductId

			  WHERE PrescriptionId = @id  
END

