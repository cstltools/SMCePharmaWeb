-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_PrescriptionDetails_ByPrescriptionId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN
	      
   Select dt.PresDetailId, dt.PrescriptionId, dt.ProductId, pro.ProductName from tbl_PrescriptionProductDetail dt 
   left join tblProduct pro on pro.ProductId = dt.ProductId
   where PrescriptionId= @id

    END

