
CREATE

 PROCEDURE [dbo].[sp_Get_BrandWiseOrderPaymentDashboard]
	-- Add the parameters for the stored procedure here

	@FrmDate nvarchar(max),
	@ToDate nvarchar(max),

	@param nvarchar(max)

AS
BEGIN 
   

    DECLARE @Q NVARCHAR(MAX)='SELECT probr.ProductSQName AS Criteria,iSNULL(SUM(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))

,0)Amount FROM dbo.tblOrder with (nolock)
   --LEFT JOIN dbo.tblOrderDetail  with (nolock) ON tblOrderDetail.OrderId = tblOrder.OrderId
    INNER JOIN dbo.tblInvoice  with (nolock) ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
   INNER JOIN dbo.tblInvoiceDetail  ID with (nolock) ON    tblInvoice.InvoiceId = ID.InvoiceId


  
   inner JOIN dbo.tblProduct pro  with (nolock) ON ID.ProductCode = pro.ProductCode
   inner JOIN dbo.tblProductSQ probr  with (nolock) ON probr.ProductBrandId = pro.ProductBrandId
   where tblOrder.OrderId is not null    

 '+@param+' 
      group by probr.ProductSQName'

   --+' union all select ''Total'' AS Criteria,ISNULL(SUM(tblInvoice.TpTotal-tblInvoice.TpDiscount),0)Amount FROM dbo.tblOrder with (nolock)
   --LEFT JOIN dbo.tblOrderDetail  with (nolock) ON tblOrderDetail.OrderId = tblOrder.OrderId
   -- INNER JOIN dbo.tblInvoice  with (nolock) ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
   --LEFT JOIN dbo.tblInvoiceDetail  with (nolock) ON tblOrderDetail.OrderDetailId = tblInvoiceDetail.OrderDetailsId

  
   --LEFT JOIN dbo.tblProduct pro  with (nolock) ON tblInvoiceDetail.ProductCode = pro.ProductCode
   --LEFT JOIN dbo.tblProductSQ probr  with (nolock) ON probr.ProductBrandId = pro.ProductBrandId
   --where tblOrder.OrderId is not null  AND MONTH(InvoiceDate)='+convert(nvarchar(max),MONTH(@Month))+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),YEAR(@Year))+'     '+@param
   
   				
EXEC sp_executesql @Q

END
             
   


