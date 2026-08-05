CREATE PROCEDURE [dbo].[sp_Get_AllSalesReportListParamNew]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN

 DECLARE @Q NVARCHAR(MAX)='
   SELECT Csapres.IdocNo, COALESCE(NULLIF(ordSend.SAPEmpCode , ''''), mas.OrderSenderCode)  as OrderSenderSAPCode, CU.SAP_Code SAPPlant, P.SAP_Code SAPProductCode,  mas.SMCType_Ord,   isnull(ID.AdjustmentAmount,0) AdjustmentAmount, 
ID.DeliveryTotalPrice GrossValue,  
ID.DeliveryTotalPriceVatAmount
TotalVat, ID.DeliveryDiscountAmount TotalDiscount, ID.DeliveryNetAmount   TotalNetPayable, SQ.ProductSQName as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,SUBSTRING(camp.CampaignName, 1, 14)   AS  ProductOffer,
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo as BatchNo ,  
 ptt.ProgramTypeName  as Type,ct.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.DeliveryTpTotal,I.DeliveryTpGrandTotal,DZSM.EmpMasterCode DZSMEmpName, 
 AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName, MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,mas.AreaCode_Ord  AreaName,mas.TerritoryCode,mas.TerritoryName_Ord TerritoryName,
 mas.SubTerritoryCode_Ord+'' : ''+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,mas.MarketName_Ord MarketName,  mas.SAPTerritoryCode_Ord, MIO.SAPEmpCode as  MIOSAPCode_Ord, AM.SAPEmpCode as AMSAPCode_Ord ,DZSM.SAPEmpCode as DZSMSAPCode_Ord, rt.RouteName,ID.ExpDate,ID.DeliveryQuantity as soldQty , tblRegion.SAP_Code                                    as ZoneSAP_Code,
tblArea.SAP_Code                                       as AreaSAP_Code,  case when  ID.ISGiftProduct =1  and ProductGroupId=3   
then ''C''     when  ID.ISGiftProduct =1 
and ProductGroupId in (1,2) then ''B''   
end                                                      as FOCType ,tblStockUOM.UOMSAPCode                                   as UoM 
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
LEFT JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
left join tblArea on mas.AreaId=tblArea.AreaId
left join tblRegion on mas.RegionId =tblRegion.RegionId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
    --LEFT JOIN tblDCStore dst ON ID.DCStoreId = dst.DCStoreId
LEFT JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
LEFT JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
LEFT JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
LEFT JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId
 LEFT JOIN SAP_API_Data..tblSalesConfirmResponseData Csapres ON CU.Customer_Code = Csapres.Code and CONVERT(date,Csapres.SalesDocDate)=CONVERT(date,I.UpdateDate)
LEFT JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId
left JOIN dbo.[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 left join tblEmpGeneralInfo ordSend on ordSend.EmpMasterCode=mas.OrderSenderCode
	 left JOIN dbo.tblUnitPrice UP ON UP.ProductCode = P.ProductCode
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
 
where ID.ISGiftProduct<>1 and ID.DeliveryStatus IN (''Full'',''Partial'')   and  
 COALESCE(NULLIF(ordSend.SAPEmpCode , ''''), mas.OrderSenderCode)   LIKE ''EE%''   ' +@Parm +'

union all

SELECT  Csapres.IdocNo, COALESCE(NULLIF(ordSend.SAPEmpCode , ''''), mas.OrderSenderCode)  as OrderSenderSAPCode, CU.SAP_Code SAPPlant, P.SAP_Code SAPProductCode,  mas.SMCType_Ord,   isnull(ID.AdjustmentAmount,0) AdjustmentAmount, 
UP.UnitPrice*ID.DeliveryQuantity GrossValue, 
UP.VATAmountPerUnit*ID.DeliveryQuantity
TotalVat, ID.DeliveryDiscountAmount TotalDiscount, ID.DeliveryNetAmount   TotalNetPayable, SQ.ProductSQName as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,SUBSTRING(camp.CampaignName, 1, 14)   AS  ProductOffer,
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo as BatchNo ,  
 ptt.ProgramTypeName  as Type,ct.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.DeliveryTpTotal,I.DeliveryTpGrandTotal,DZSM.EmpMasterCode DZSMEmpName, 
 AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName  , MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,mas.AreaCode_Ord  AreaName,mas.TerritoryCode,mas.TerritoryName_Ord TerritoryName,
 mas.SubTerritoryCode_Ord+'' : ''+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,  mas.MarketName_Ord MarketName,  mas.SAPTerritoryCode_Ord, MIO.SAPEmpCode as  MIOSAPCode_Ord, AM.SAPEmpCode as AMSAPCode_Ord ,DZSM.SAPEmpCode as DZSMSAPCode_Ord, rt.RouteName,ID.ExpDate,ID.DeliveryQuantity as soldQty ,  tblRegion.SAP_Code    as ZoneSAP_Code,
tblArea.SAP_Code                                       as AreaSAP_Code ,  case when  ID.ISGiftProduct =1  and ProductGroupId=3   
then ''C''     when  ID.ISGiftProduct =1 
and ProductGroupId in (1,2) then ''B''   
end                                                      as FOCType ,tblStockUOM.UOMSAPCode                                   as UoM 
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
LEFT JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
left join tblArea on mas.AreaId=tblArea.AreaId
left join tblRegion on mas.RegionId =tblRegion.RegionId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
    --LEFT JOIN tblDCStore dst ON ID.DCStoreId = dst.DCStoreId
LEFT JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
LEFT JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
left join tblStockUOM with(nolock) on tblStockUOM.StockUOMId=P.StockUOMId
LEFT JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
LEFT JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId
 LEFT JOIN SAP_API_Data..tblSalesConfirmResponseData Csapres ON CU.Customer_Code = Csapres.Code and CONVERT(date,Csapres.SalesDocDate)=CONVERT(date,I.UpdateDate)
left JOIN dbo.tblUnitPrice UP ON UP.ProductCode = P.ProductCode



LEFT JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId
left JOIN dbo.[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType


LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)  ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
left join tblEmpGeneralInfo ordSend on ordSend.EmpMasterCode=mas.OrderSenderCode	 
left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
 
where ID.ISGiftProduct=1 and ID.DeliveryStatus IN (''Full'',''Partial'')    and  
 COALESCE(NULLIF(ordSend.SAPEmpCode , ''''), mas.OrderSenderCode)   LIKE ''EE%''  ' +@Parm 
 EXEC sp_executesql @Q
END
             



--                       and CU.ComUnitId='" + districtId.Trim() + "' and I.UpdateDate between '" + fromDate + "' and '" + toDate + "' 