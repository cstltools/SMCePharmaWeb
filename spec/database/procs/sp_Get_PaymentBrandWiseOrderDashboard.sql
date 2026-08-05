
CREATE

 PROCEDURE [dbo].[sp_Get_PaymentBrandWiseOrderDashboard]
	-- Add the parameters for the stored procedure here

	@param nvarchar(max),
	@FrmDate nvarchar(max),
	@ToDate nvarchar(max)

AS
BEGIN 
   

    DECLARE @Q NVARCHAR(MAX)='SELECT  Convert(Date,tblInvoice.UpdateDate) UpdateDate, format( Convert(Date,tblInvoice.UpdateDate),''dd-MMM'') Criteria, floor(ISNULL(SUM(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))

,0)) Amount FROM dbo.tblOrder with (nolock)
   --LEFT JOIN dbo.tblOrderDetail  with (nolock) ON tblOrderDetail.OrderId = tblOrder.OrderId
    INNER JOIN dbo.tblInvoice  with (nolock) ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
     INNER JOIN dbo.tblInvoiceDetail  ID with (nolock) ON tblInvoice.InvoiceId = ID.InvoiceId

  
   inner JOIN dbo.tblProduct pro  with (nolock) ON ID.ProductCode = pro.ProductCode
   inner JOIN dbo.tblProductSQ probr  with (nolock) ON probr.ProductBrandId = pro.ProductBrandId
   where tblOrder.OrderId is not null    and format( Convert(Date,tblInvoice.UpdateDate),''dd-MMM'') is not null  '+@param+'   
      group by format( Convert(Date,tblInvoice.UpdateDate),''dd-MMM''), Convert(Date,tblInvoice.UpdateDate)   order by Convert(Date,tblInvoice.UpdateDate)  asc '

   --+' union all select ''Total'' AS Criteria,ISNULL(SUM(tblInvoice.TpTotal-tblInvoice.TpDiscount),0)Amount FROM dbo.tblOrder with (nolock)
   --LEFT JOIN dbo.tblOrderDetail  with (nolock) ON tblOrderDetail.OrderId = tblOrder.OrderId
   -- INNER JOIN dbo.tblInvoice  with (nolock) ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
   --LEFT JOIN dbo.tblInvoiceDetail  with (nolock) ON tblOrderDetail.OrderDetailId = tblInvoiceDetail.OrderDetailsId

  
   --LEFT JOIN dbo.tblProduct pro  with (nolock) ON tblInvoiceDetail.ProductCode = pro.ProductCode
   --LEFT JOIN dbo.tblProductSQ probr  with (nolock) ON probr.ProductBrandId = pro.ProductBrandId
   --where tblOrder.OrderId is not null  AND MONTH(InvoiceDate)='+convert(nvarchar(max),MONTH(@Month))+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),YEAR(@Year))+'     '+@param
   
   				
EXEC sp_executesql @Q

END
             
   


