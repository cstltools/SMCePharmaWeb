CREATE PROCEDURE [dbo].[sp_Get_AllSalesReportListParam2]
	-- Add the parameters for the stored procedure here
	 @NewParm nvarchar(max) ,
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='SELECT mas.paymenttype,  mas.SMCType_Ord,   isnull(ID.AdjustmentAmount,0) AdjustmentAmount, ID.PaymentTotalPrice GrossValue, ID.PaymentTotalPriceVatAmount
TotalVat, ID.PaymentDiscountAmount TotalDiscount, ID.PaymentNetAmount   TotalNetPayable, SQ.ProductSQName as Brand  ,CU.ComUnitCode,CU.ComUnitName,mas.CustomerCode,mas.CustomerName,
I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer, masdtl.CampaignName   AS  ProductOffer,
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.FinalPaymentNo DelivaryInvoiceNo, CONVERT(VARCHAR,tblCustPay.custPaymentDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,convert(nvarchar(max),ID.BatchNo) BatchNo ,  
 ptt.ProgramTypeName  as Type,ct.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.PaymentTpTotal,I.PaymentTpGrandTotal,DZSM.EmpMasterCode DZSMEmpName, 
 AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName  , MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,mas.AreaCode_Ord  AreaName,mas.TerritoryCode,mas.TerritoryName_Ord TerritoryName,
 mas.SubTerritoryCode_Ord+'' : ''+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,  mas.MarketName_Ord MarketName,rt.RouteName,ID.ExpDate,ID.PaymentQuantity as soldQty, masdtl.CampaignCategory
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
    --LEFT JOIN tblDCStore dst ON ID.DCStoreId = dst.DCStoreId
--INNER JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId 
LEFT JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId
--left JOIN dbo.[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
 inner join (select InvoiceId,  sum(TPAmount) + sum(VATAmount) CustPayAmount, max(custPaymentDate) custPaymentDate from tblCustPayDetail group by InvoiceId) tblCustPay on I.InvoiceId =tblCustPay.InvoiceId
 inner join (select InvoiceId, SUM(PaymentNetAmount) PaymentNetAmount from tblInvoiceDetail group by InvoiceId) tblNetPay on I.InvoiceId =tblNetPay.InvoiceId


 where tblNetPay.PaymentNetAmount<= tblCustPay.CustPayAmount  ' +@NewParm + @Parm2




						
EXEC sp_executesql @Q

END
             



--                       and CU.ComUnitId='" + districtId.Trim() + "' and I.UpdateDate between '" + fromDate + "' and '" + toDate + "' 



--' 		union all	 SELECT '''' SMCType_Ord, 0 as AdjustmentAmount  , ID.DeliveryTotalPrice GrossValue, ID.DeliveryTotalPriceVatAmount
--TotalVat, ID.DeliveryDiscountAmount TotalDiscount, ID.DeliveryNetAmount   TotalNetPayable,

--SQ.ProductSQName as Brand ,

--CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,
--CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,
--SUBSTRING(Campaign, 1, 14)  AS ProductOffer,
--CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo,
-- CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,
--ID.ProductName,ID.PackSize,convert(nvarchar(max),ID.BatchNo) BatchNo,I.Types as Type,I.CustomerType as NewType,
--I.TpGrandTotal,TpTotal,
--I.DeliveryTpTotal,I.DeliveryTpGrandTotal, 
--I.RegionCode as DZSMEmpName, I.DisCode AMEmpCode, ''-'' AMEmpName  ,  I.MiAcode  MIOEmpCode, I.MiaNAme MIOEmpName, ''-'' as GroupName,I.RegionCode as RegionName,
--I.DisCode  as AreaName,I.AreaCode    as TerritoryCode,
--I.AreaCode    as   TerritoryName,
--''-'' as SubTerritoryName,I.MarketCode, I.MarketName as MarketName,''-'' as RouteName,ID.ExpDate,ID.DeliveryQuantity as soldQty


--FROM SalesDisDB_SMC..tblInvoice I  with(nolock)
--INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
--INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
--INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
--INNER JOIN SalesDisDB_SMC..tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
--INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
--INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
--where ID.DeliveryStatus IN (''Full'',''Partial'') '  +@Parm 

--+

--' 		union all	 SELECT '''' SMCType_Ord, 0 as AdjustmentAmount  , ID.DeliveryTotalPrice GrossValue, ID.DeliveryTotalPriceVatAmount
--TotalVat, ID.DeliveryDiscountAmount TotalDiscount, ID.DeliveryNetAmount   TotalNetPayable,

--SQ.ProductSQName as Brand ,

--CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,
--CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,
--   SUBSTRING(Campaign, 1, 14)  AS ProductOffer,
--CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo,
-- CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,
--ID.ProductName,ID.PackSize,ID.BatchNo,I.ProgramType as Type,I.CustomerType as NewType,
--I.TpGrandTotal,TpTotal,
--I.DeliveryTpTotal,I.DeliveryTpGrandTotal, 
--I.RegionCode as DZSMEmpName, I.DisCode AMEmpCode, ''-'' AMEmpName  ,I.MiAcode as  MIOEmpCode, I.MiaNAme as MIOEmpName,''-'' as GroupName,I.RegionCode as RegionName,
--I.DisCode  as AreaName,I.AreaCode  as TerritoryCode,
--I.AreaCode  as   TerritoryName,
--''-'' as SubTerritoryName,I.MarketCode, I.MarketName as MarketName,''-'' as RouteName,ID.ExpDate,ID.DeliveryQuantity as soldQty


--FROM SalesDisDB_SMC..tblSubInvoiceMaster I  with(nolock)
--INNER JOIN SalesDisDB_SMC..tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
--INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
--INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
----INNER JOIN SalesDisDB_SMC..tblSubDepotStore DS ON DS.DCStoreId = ID.DCStoreId 
--INNER JOIN SalesDisDB_SMC..tblProduct P ON ID.ProductCode = P.ProductCode 
--INNER JOIN SalesDisDB_SMC..tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
--where ID.DeliveryStatus IN (''Full'',''Partial'') '  +@Parm 