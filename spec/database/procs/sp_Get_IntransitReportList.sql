
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_IntransitReportList]
	-- Add the parameters for the stored procedure here
	@districtId nvarchar(max)=null,
	@fromDate datetime=null,
	@toDate datetime=null


AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
SELECT cus.CellNo, mas.ComUnitCode ComUnitCode, MIO.EmpMasterCode MainMIOCODE, MIO.EmpName MainMIONAME, typ.CustomerType as CustomerType, tblarea.AreaCode AMCode,
  tblregion.RegionCode  DZSMCode, tblDetails.TotalPriceVatAmount TradeDiscount,
  tblTerritory.TerritoryCode  Territory, '''' fromdate , '''' todate ,
  tblDetails.DeliveryNetAmount AS  ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
  I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,tblDetails.NetAmount AS NetAmount,
  tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode 
  AS DistrictCode,mas.MarketCode_Ord MarketCode,mas. MarketName_Ord MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,MIO.EmpMasterCode  as MainMIOCODE,MIO.EmpName  as 
  MainMIONAME,I.CustomerType as SpecialAmount 



FROM dbo.tblInvoice I WITH(nolock) 

INNER JOIN ( select InvoiceId, sum(NetAmount)NetAmount, ((Sum(DeliveryTotalPrice)+Sum(DeliveryTotalPriceVatAmount))-Sum(DeliveryDiscountAmount))DeliveryNetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount 

from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId 

INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 

INNER JOIN tblOrder mas ON mas.OrderId = I.OrderId 
INNER JOIN tblCustMaster cus ON mas.[CustomerMasterId] = cus.CustomerMasterId 

 left  JOIN tblCustomerType typ ON typ.CustomerTypeId = mas.CustTypeId 
  
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId


LEFT JOIN tblMarket  with (nolock)  ON tblMarket.MarketId=cus.MarketId
LEFT JOIN tblSubTerritory  with (nolock)  ON tblSubTerritory.SubTerritoryId=tblMarket.SubTerritoryId
LEFT JOIN tblTerritory  with (nolock)  ON tblTerritory.TerritoryId=tblSubTerritory.TerritoryId
LEFT JOIN tblarea  with (nolock)  ON tblarea.AreaId=tblTerritory.AreaId
LEFT JOIN tblregion  with (nolock)  ON tblregion.RegionId=tblarea.RegionId


where I.TpTotal>0  and I.DelivaryInvoiceNo IS NULL  '+@districtId  +'

 union all 

 SELECT '''' CellNo, CU.ComUnitCode,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as 
 CustomerType,I.DisCode as AMCode,I.RegionCode  as DZSMCode,tblDetails.TotalPriceVatAmount  AS TradeDiscount,
 I.AreaCode  as Territory,''-''  as fromdate,''-''  as todate,

  tblDetails.NetAmount AS ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
I.OrderNo,
 CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,
CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,tblDetails.NetAmount
 AS NetAmount,tblDetails.UnitVatAmount AS 
 TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,

I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,
 I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay

,I.MIACode as MainMIOCODE,I.MIAName as 
  MainMIONAME,I.CustomerType as SpecialAmount 
 
FROM SalesDisDB_SMC..tblInvoice I WITH(nolock) 
INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)
UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from SalesDisDB_SMC..tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId 
INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN SalesDisDB_SMC..View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
 where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL '+@districtId  +'

-- union all 

-- SELECT '''' CellNo, CU.ComUnitCode,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as 
-- CustomerType,I.DisCode as AMCode,I.RegionCode  as DZSMCode,tblDetails.TotalPriceVatAmount  AS TradeDiscount,
-- I.AreaCode  as Territory,''-''  as fromdate,''-''  as todate,

--  tblDetails.NetAmount AS ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
--I.OrderNo,
-- CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,
--CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,tblDetails.NetAmount
-- AS NetAmount,tblDetails.UnitVatAmount AS 
-- TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,

--I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,
-- I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay

--,I.MIACode as MainMIOCODE,I.MIAName as 
--  MainMIONAME,I.CustomerType as SpecialAmount 
 
--FROM SalesDisDB_SMC..tblSubInvoiceMaster I WITH(nolock) 
--INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)
--UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from SalesDisDB_SMC..tblSubInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId 
--INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
--INNER JOIN SalesDisDB_SMC..View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
-- where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL '+@districtId
 
	EXEC sp_executesql @Q
END





  
            



