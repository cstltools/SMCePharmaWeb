-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DCRProductList]
	-- Add the parameters for the stored procedure here
	@DcrId INT 
AS
BEGIN
	 
	SELECT  dtl.ProductId, pro.ProductCode+' : '+pro.ProductName ProductName, FLOOR(ISNULL(dtl.ProductQty,0)) ProductQty
        
             FROM dbo.tbl_DcrDetails dtl with (nolock)
			 left join tblProduct pro on dtl.ProductId=pro.ProductId

			  WHERE dtl.DcrId = @DcrId
END

