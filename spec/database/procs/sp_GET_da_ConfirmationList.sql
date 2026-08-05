CREATE   PROCEDURE [dbo].[sp_GET_da_ConfirmationList]
	-- Add the parameters for the stored procedure here
	@ComUnitId int,
	@RouteId int,
	@daid int


AS
BEGIN

 SELECT   tblCompanyUnit.ComUnitName distributionCenter,  tblOrder.DistributionRoute_Ord  RouteName,  tblCompanyUnit.ComUnitCode+':'+  tblCompanyUnit.ComUnitName saleCenter, '' feName,   tblOrder.CustomerType, tblOrder.MIOCode, tblOrder.MIOName, tblInvoice.InvoiceNo,  tblOrder.OrderCode OrderNo, tblOrder.Remarks, FORMAT(tblOrder.SubmissionDate,'dd-MMM-yyyy') OrderDate,  FORMAT(tblInvoice.InvoiceDate,'dd-MMM-yyyy')  InvoiceDate ,tblOrder.CustomerCode, tblOrder.CustomerName, tblOrder.OrderSenderName, tblOrder.ComUnitId,tblOrder.ManufacId,tblOrder.OrderId,tblInvoice.InvoiceId,tblOrder.MarketId,tblOrder.CustomerMasterId, tblInvoice.InvoiceId,  
    CASE 
        WHEN MONTH(InvoiceDate) = MONTH(GETDATE()) AND YEAR(InvoiceDate) = YEAR(GETDATE()) THEN 'Partial Show'
        ELSE 'Partial Offs'
    END AS   IsPartialCheck, isnull(IsAdjustInvoice,0) IsAdjustInvoice,  tblOrder.OrderSenderCode+' : '+tblOrder.OrderSenderName OrderSenderName,  tblD.ManufacId TpGrandTotal, tblOrder.TerritoryName_Ord MarketName,   tblOrder.MarketName_Ord MarketName,  tblInvoice.CustomerMasterId,tblOrder.MarketId  FROM dbo.tblOrder With (nolock)
            
            inner JOIN dbo.tblInvoice  With (nolock) ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 

          --  inner JOIN dbo. tblCustMaster  V   With (nolock)  ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit  With (nolock) ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
                     --  inner JOIN dbo.tblMarket  With (nolock) ON tblOrder.MarketId = dbo.tblMarket.MarketId  
					     INNER JOIN (SELECT DISTINCT D.InvoiceId, sum(NetAmount)ManufacId FROM tblInvoiceDetail D  with (nolock)
                    
                    group by  D.InvoiceId   ) as tblD ON tblInvoice.InvoiceId = tblD.InvoiceId   
            WHERE  TpGrandTotal>0  AND( DelivaryInvoiceNo IS    NULL )   and  tblOrder.ComUnitId= @ComUnitId and  tblOrder.DistributionRouteId= @RouteId 
           AND LTRIM(RTRIM(ISNULL(DA_SalesConfirmStatus, ''))) NOT IN ('Pending', 'Approved', 'Canceled' ,'Partial')
           order by InvoiceDate asc

            end
