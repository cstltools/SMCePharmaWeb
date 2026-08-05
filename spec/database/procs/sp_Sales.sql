-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Sales]
	
AS
BEGIN
truncate table SystemTest..Sales
	 Insert INTO SystemTest..Sales
	         ( SalesCenter ,
	           SalesCenterName ,
	           CustomerID ,
	           CustomerName ,
	           OrderNo ,
	           OrderSubmissionDate ,
	           ProformaNumber ,
	           ProformaDate ,
	           InvoiceNumber ,
	           InvoiceDate ,
	           ProductCode ,
	           ProductName ,
	           PackSize ,
	           BatchNo ,
	           ExpDate ,
	           SoldQty ,
	           NetSalesAmount ,
	           VatAmount ,
	           TradeDiscount ,
	           SpecialDiscount ,
	           MarketCode ,
	           MarketName ,
	           TerritoryCode ,
	           MIOCode ,
	           FECode ,
	           DZSMCode
	         ) 
	
SELECT CU.ComUnitCode
,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.OrderDate as OrderDate
,I.InvoiceNo,
I.InvoiceDate as InvoiceDate,I.DelivaryInvoiceNo, I.UpdateDate as UpdateDate,
ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,DS.ExpDate as ExpDate,ID.DeliveryQuantity,
DeliveryNetAmount,
DeliveryTotalPriceVatAmount,DeliveryDiscountAmount,ID.DelivarySpecialAmount,MK.MarketCode,MK.MarketName,
A.AreaCode,MI.MiaCode,DIS.DistrictCode , R.RegionCode
FROM dbo.tblInvoice I 
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
LEFT JOIN dbo.tblArea A ON A.AreaId = C.AreaId
LEFT JOIN dbo.tblMIAInfo MI ON MI.MiaId =C.MiaId 
LEFT JOIN dbo.tblDistrict DIS ON DIS.DistrictId = C.DistrictId
LEFT JOIN dbo.tblMarket MK ON C.MarketCode = MK.MarketCode
INNER JOIN dbo.tblRegion R ON R.RegionId = C.RegionId
where ID.DeliveryStatus IN ('Full','Partial') 
and I.UpdateDate between (DATEADD(DAY, -2, CONVERT(VARCHAR(10),GETDATE(),101))) and CONVERT(VARCHAR(10),GETDATE(),101)

        
         insert into SystemTest..ReportLog (ReportName,TransectionTime)
                  values ('Sales Report',GETDATE())
END
