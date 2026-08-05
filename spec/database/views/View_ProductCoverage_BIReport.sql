
CREATE VIEW [dbo].[View_ProductCoverage_BIReport] 
AS
SELECT mas.GroupName_Ord Group_Name,    mas.GroupCode_Ord Group_Code,  
 mas.RegionCode_Ord [Zone_Code],mas.RegionName_Ord  [Zone_Name],ddd.AreaCode  [Area_Code],ddd.AreaName  [Area_Name],cc.TerritoryCode as Territory_Code,mas.TerritoryName_Ord Territory_Name , P.ProductCode Product_Code, P.ProductName Product_Name ,SQ.ProductSQName Product_Brand,sum(ID.DeliveryNetAmount)  Sales_Amount, isnull(CustPayAmount,0) [Customer_Payment_Amount], CONVERT(date,I.UpdateDate)  Sales_Date   
FROM dbo.tblInvoice I  with(nolock)
left join (select mas.InvoiceId, SUM(TPAmount+VATAmount) CustPayAmount from tblCustPayDetail mas group by mas.InvoiceId) tblCustPay on I.InvoiceId=tblCustPay.InvoiceId
INNER JOIN dbo.tblInvoiceDetail ID   with(nolock) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas   with(nolock) ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt   with(nolock) ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct   with(nolock) ON mas.CusttypeId = ct.CustomerTypeId
    LEFT JOIN tblDCStore dst   with(nolock) ON ID.DCStoreId = dst.DCStoreId
INNER JOIN tblCustMaster C   with(nolock) ON C.CustomerMasterId = mas.CustomerMasterId
INNER JOIN dbo.tblProduct P    with(nolock) ON ID.ProductCode = P.ProductCode 
INNER JOIN dbo.tblProductSQ SQ   with(nolock) ON P.ProductBrandId = SQ.ProductBrandId 
INNER JOIN dbo.tblCompanyUnit CU   with(nolock) ON CU.ComUnitId = mas.ComUnitId



LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1



LEFT JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId
 
 
where ID.DeliveryStatus IN ('Full','Partial')

group by mas.GroupName_Ord  ,    mas.GroupCode_Ord  ,  
 mas.RegionCode_Ord  ,mas.RegionName_Ord  ,ddd.AreaCode ,ddd.AreaName  ,cc.TerritoryCode  ,mas.TerritoryName_Ord   , P.ProductCode  , P.ProductName   ,SQ.ProductSQName  ,  CustPayAmount, CONVERT(date,I.UpdateDate)
