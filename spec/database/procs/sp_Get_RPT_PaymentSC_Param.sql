CREATE PROCEDURE [dbo].[sp_Get_RPT_PaymentSC_Param]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='SELECT  mas.SMCType_Ord,   isnull(ID.AdjustmentAmount,0) AdjustmentAmount, ISNULL(ID.DeliveryTotalPrice- ID.PaymentTotalPrice,0) GrossValue, isnull(ID.DeliveryTotalPriceVatAmount- ID.PaymentTotalPriceVatAmount,0) 
TotalVat, isnull( ID.DeliveryDiscountAmount- ID.PaymentDiscountAmount,0) TotalDiscount, ID.PaymentNetAmount   TotalNetPayable, SQ.ProductSQName as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,SUBSTRING(camp.CampaignName, 1, 14)   AS  ProductOffer,
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate, I.PaymentInvoiceNo PaymentInvoiceNo, CONVERT(VARCHAR,I.PaymentDate,103) PaymentDate,ID.ProductCode,ID.ProductName,ID.PackSize,convert(nvarchar(max),dst.BatchNo) BatchNo ,  
 ptt.ProgramTypeName  as Type,ct.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.PaymentTpTotal DeliveryTpTotal,I. PaymentTpGrandTotal DeliveryTpGrandTotal,DZSM.EmpMasterCode DZSMEmpName, 
 AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName  , MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,mas.AreaCode_Ord  AreaName,mas.TerritoryCode,mas.TerritoryName_Ord TerritoryName,
 mas.SubTerritoryCode_Ord+'' : ''+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,  mas.MarketName_Ord MarketName,rt.RouteName,ID.ExpDate, isnull(DeliveryTotalQuantity,0)- isnull(PaymentTotalQuantity,0)  as soldQty
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
    LEFT JOIN tblDCStore dst ON ID.DCStoreId = dst.DCStoreId
INNER JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId


LEFT JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId
left JOIN dbo.[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType


LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 
	 
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
 
where I.PaymentInvoiceNo is not null  and isnull(PaymentTotalQuantity,0)  <> isnull(DeliveryTotalQuantity,0)' +@Parm + @Parm2   
						
EXEC sp_executesql @Q

END
             



--                       and CU.ComUnitId='" + districtId.Trim() + "' and I.UpdateDate between '" + fromDate + "' and '" + toDate + "' 