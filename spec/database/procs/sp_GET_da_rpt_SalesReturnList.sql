 
CREATE   PROCEDURE [dbo].[sp_GET_da_rpt_SalesReturnList]
	-- Add the parameters for the stored procedure here
	@ComUnitId int,
	@RouteId int,
	@daid int,
	@frmDate date,
	@toDate date




AS
BEGIN


SELECT DZSM.EmpMasterCode DZSMEmpName,  AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName, MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,mas.AreaCode_Ord  AreaName,mas.TerritoryCode,mas.TerritoryName_Ord TerritoryName,
 mas.SubTerritoryCode_Ord+' : '+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,mas.MarketName_Ord MarketName,  mas.SAPTerritoryCode_Ord, MIO.SAPEmpCode as  MIOSAPCode_Ord, AM.SAPEmpCode as AMSAPCode_Ord ,DZSM.SAPEmpCode as DZSMSAPCode_Ord,format(ID.ExpDate,'dd-MMM-yyyy') ExpDate,ID.DeliveryQuantity as soldQty , tblRegion.SAP_Code                                    as ZoneSAP_Code,
tblArea.SAP_Code                                       as AreaSAP_Code,  case when  ID.ISGiftProduct =1  and ProductGroupId=3   
then 'C'     when  ID.ISGiftProduct =1 
and ProductGroupId in (1,2) then 'B'   
end                                                      as FOCType ,tblStockUOM.UOMSAPCode                                   as UoM ,  COALESCE(NULLIF(ordSend.SAPEmpCode , ''), mas.OrderSenderCode)  as OrderSenderSAPCode, CU.SAP_Code SAPPlant, P.SAP_Code SAPProductCode, sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)) ReturnAmountDiscount ,  sum(ISNULL(ID.DeliveryTotalQuantity- ID.PaymentTotalQuantity,0)) ReturnQty,      sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0))
AS ReturnAmountTP, sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)) ReturnAmountVat,
(sum(ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0)) + sum( isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0)))-sum(ISNULL(ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0)) ReturnGrossAmt , mas.SMCType_Ord,  I.ComUnitId, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,pt. ProgramTypeName as ProgramType,ct.CustomerType as CustomerType,I.OrderNo, format(I.OrderDate,'dd-MMM-yyyy')  AS
 OrderDate,I.InvoiceNo,
format(I.InvoiceDate,'dd-MMM-yyyy')	as InvoiceDate,I.DelivaryInvoiceNo,Convert(varchar,I.UpdateDate,103)	as UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,tblDCStore.BatchNo, format(DS.ExpDate,'dd-MMM-yyyy') as ExpDate,
  mas.MarketCode_Ord MarketCode,mas.MarketName_Ord MarketName,
 mas.TerritoryCode AreaCode,MIO.EmpMasterCode  MiaCode,AM.EmpMasterCode as DistrictCode , DZSM.EmpMasterCode RegionCode,ReturnReason,
  format(I.PaymentDate,'dd-MMM-yyyy')	as ReturnDate,mas.AreaCode_Ord AreaCodeNew, mas.RegionCode_Ord RegionCodeNew  
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblOrder mas ON mas.OrderId = I.OrderId
left join tblArea on mas.AreaId=tblArea.AreaId
left join tblRegion on mas.RegionId =tblRegion.RegionId
left JOIN dbo.tblProgramType pt  with(nolock) ON mas.ProgramTypeId = pt.ProgramTypeId
left JOIN dbo.tblCustomerType ct  with(nolock) ON mas.CustTypeId = ct.CustomerTypeId
		LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
 left join tblEmpGeneralInfo ordSend on ordSend.EmpMasterCode=mas.OrderSenderCode
 LEFT JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
LEFT JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
	 left JOIN dbo.tblUnitPrice UP ON UP.ProductCode = P.ProductCode
	 	 left join tblDCStore on tblDCStore.DCStoreId =iD.DCStoreId
		
where I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0)     and  mas.ComUnitId= @ComUnitId and  mas.DistributionRouteId= @RouteId  AND CONVERT(date,I.PaymentDate)  BETWEEN @frmDate and @toDate
group by DZSM.EmpMasterCode  , 
 AM.EmpMasterCode  , AM.EmpName  , MIO.EmpMasterCode   , MIO.EmpName    , mas.GroupCode_Ord  ,
 mas.RegionCode_Ord  ,mas.AreaCode_Ord   ,mas.TerritoryCode,mas.TerritoryName_Ord  ,
 mas.SubTerritoryCode_Ord+' : '+  mas.SubTerritoryName_Ord  , mas.MarketCode_Ord  ,mas.MarketName_Ord  ,  mas.SAPTerritoryCode_Ord, MIO.SAPEmpCode , AM.SAPEmpCode  ,DZSM.SAPEmpCode  , format(ID.ExpDate,'dd-MMM-yyyy')  ,ID.DeliveryQuantity   , tblRegion.SAP_Code                                  ,
tblArea.SAP_Code                                          ,  case when  ID.ISGiftProduct =1  and ProductGroupId=3   
then 'C'     when  ID.ISGiftProduct =1 
and ProductGroupId in (1,2) then 'B'   
end    ,tblStockUOM.UOMSAPCode , COALESCE(NULLIF(ordSend.SAPEmpCode , ''), mas.OrderSenderCode)  , CU.SAP_Code  , P.SAP_Code  , mas.SMCType_Ord,  I.ComUnitId, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,pt. ProgramTypeName  ,ct.CustomerType  ,I.OrderNo,format(I.OrderDate,'dd-MMM-yyyy')   ,I.InvoiceNo,
 format(I.InvoiceDate,'dd-MMM-yyyy') ,I.DelivaryInvoiceNo,Convert(varchar,I.UpdateDate,103)	 ,ID.ProductCode,ID.ProductName,ID.PackSize,tblDCStore.BatchNo,format(DS.ExpDate,'dd-MMM-yyyy') ,format(ID.ExpDate,'dd-MMM-yyyy'),  mas.MarketCode_Ord  ,mas.MarketName_Ord  ,
 mas.TerritoryCode  ,MIO.EmpMasterCode   ,AM.EmpMasterCode   ,  ReturnReason, Convert(varchar,I.UpdateDate,103), format(I.PaymentDate,'dd-MMM-yyyy')	 ,mas.AreaCode_Ord  , mas.RegionCode_Ord

end
