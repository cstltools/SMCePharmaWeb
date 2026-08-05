-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeliveryReturn]
	
AS
BEGIN
truncate table SystemTest..DeliveryReturn

	 Insert INTO SystemTest..DeliveryReturn
	         ( SalesCenter ,
	           SalesCenterName ,
	           CustomerID ,
	           CustomerName ,
	           OrderNo ,
	           OrderSubmissionDate ,
	           ProformaNumber ,
	           ProformaDate ,
	           InvoiceNumber ,
	           ProductCode ,
	           ProductName ,
	           PackSize ,
	           BatchNo ,
	           ExpDate ,
	           ReturnQty ,
	           ReturnAmount ,
	           VatAmount ,
	           MarketCode ,
	           MarketName ,
	           TerritoryCode ,
	           FECode ,
	           DZSMCode ,
	           ReturnReason ,
	           ReturnDate
	         )
SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,
I.OrderDate as OrderDate,I.InvoiceNo,
I.InvoiceDate	as InvoiceDate,I.DelivaryInvoiceNo,
--CONVERT(varchar,I.UpdateDate,103) as UpdateDate,
ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,DS.ExpDate as ExpDate,
(ID.Quantity-ID.DeliveryQuantity)Quantity,(ID.NetAmount-ID.DeliveryNetAmount)Amount,
(ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount)VatAmount,MK.MarketCode,MK.MarketName
,A.AreaCode,DIS.DistrictCode , R.RegionCode,ReturnReason,
I.UpdateDate	as UpdateDate 
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
where ID.DeliveryStatus IN ('Reject','Partial') 
 
 AND I.UpdateDate between (DATEADD(DAY, -2, CONVERT(VARCHAR(10),GETDATE(),101))) and CONVERT(VARCHAR(10),GETDATE(),101)
                  
        
        insert into SystemTest..ReportLog (ReportName,TransectionTime)
                  values ('DeliveryReturn Report',GETDATE())
END
