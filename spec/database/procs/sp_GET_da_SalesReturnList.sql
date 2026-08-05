--------------------------------------------------
-- PROCEDURE: sp_GET_da_SalesReturnList
--------------------------------------------------
CREATE   PROCEDURE [dbo].[sp_GET_da_SalesReturnList]
	-- Add the parameters for the stored procedure here
	@ComUnitId int,
	@RouteId int,
	@daid int
AS
BEGIN
 SELECT  ord.ComUnitName distributionCenter,  ord.DistributionRoute_Ord  RouteName,  ord.ComUnitCode+':'+  ord.ComUnitName saleCenter, '' feName,   ord.CustomerType, ord.MIOCode, ord.MIOName, INV.InvoiceId, INV.InvoiceNo   InvoiceNo,  ord.OrderCode OrderNo, ord.Remarks, FORMAT(ord.SubmissionDate,'dd-MMM-yyyy') OrderDate,  FORMAT(INV.InvoiceDate,'dd-MMM-yyyy')  InvoiceDate ,ord.CustomerCode, ord.CustomerName, ord.OrderSenderName, ord.TerritoryName_Ord,   ord.MarketId,ord.DistributionRouteId,     isnull(IsAdjustInvoice,0) IsAdjustInvoice,  tblD.ManufacId TpGrandTotal, case when   (CONVERT(date,INV.InvoiceDate))>=   (CONVERT(date,'30-June-2022')) then 'True' else 'False' end chkStatus ,INV.CustomerMasterId,tblMarket.MarketId  FROM dbo.tblOrder ord With (nolock)
            
            inner JOIN dbo.tblInvoice INV  With (nolock) ON ord.OrderId=INV.OrderId 
            --inner JOIN dbo. tblCustMaster  V   With (nolock)  ON ord.CustomerMasterId = V.CustomerMasterId
            inner JOIN dbo.tblCompanyUnit  With (nolock) ON ord.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
                       inner JOIN dbo.tblMarket  With (nolock) ON ord.MarketId = dbo.tblMarket.MarketId  
					     INNER JOIN (SELECT DISTINCT D.InvoiceId, case when IV.DeliveryInvoiceStatus='Partial' then sum(D.DeliveryNetAmount) else  sum(NetAmount) end ManufacId FROM tblInvoiceDetail D  with (nolock)
                     inner JOIN dbo.tblInvoice  IV With (nolock) ON D.InvoiceId=IV.InvoiceId 
                    group by  D.InvoiceId,IV.DeliveryInvoiceStatus   ) as tblD ON INV.InvoiceId = tblD.InvoiceId   
            WHERE  TpGrandTotal>0 AND    DelivaryInvoiceNo  is not null   and  ord.ComUnitId= @ComUnitId 
            and  ord.DistributionRouteId= @RouteId  
            AND INV.InvoiceDate >= DATEADD(MONTH, -3, CAST(GETDATE() AS DATE))
            AND INV.InvoiceDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
            --AND LTRIM(RTRIM(ISNULL(DA_SalesReturn, ''))) NOT IN ('Pending', 'Approved', 'Canceled')
           order by INV.InvoiceDate asc

            end