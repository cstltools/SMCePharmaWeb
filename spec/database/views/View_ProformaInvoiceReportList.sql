CREATE view View_ProformaInvoiceReportList
as

SELECT mas.paymenttype, mas.SMCType_Ord,  pt. ProgramTypeName as Type, ct.CustomerType   IntransitDay,  isnull(ID.AdjustmentAmount,0) AdjustmentAmount, ID.NetAmount as TotalNetPayable,
     ID.TotalPrice AS GrossValue,ID.totalPriceVatAmount AS TotalVat,ID.DiscountAmount  AS TotalDiscount, CU.ComUnitCode,CU.ComUnitName,mas.CustomerCode,mas.CustomerName,
	 I.OrderNo,I.FixedCustomer, 	
	  masdtl.CampaignName   AS ProductOffer ,
	-- camp.CampaignName  AS ProductOffer ,
CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize, dbo.fn_CleanRows(DS.BatchNo)  BatchNo ,
CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,DZSM.EmpMasterCode+' : '+DZSM.EmpName DZSMEmpName, mas.AreaCode_Ord AMEmpCode,mas.AreaName_Ord AMEmpName,MIO.EmpMasterCode  MIOEmpCode, 
MIO.EmpName MIOEmpName  , mas.GroupCode_Ord  GroupName,mas.RegionCode_Ord   RegionName,mas.AreaCode_Ord  AreaName,mas.TerritoryCode_Ord TerritoryCode,mas.TerritoryName_Ord TerritoryName,
mas.SubTerritoryCode_Ord+' : '+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode, mas.MarketName_Ord MarketName,rt.RouteName, masdtl.CampaignCategory
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID  with(nolock) ON ID.InvoiceId = I.InvoiceId
 

left JOIN dbo.tblDCStore DS  with(nolock) ON DS.DCStoreId = ID.DCStoreId
left JOIN dbo.tblOrder mas  with(nolock) ON I.OrderId = mas.OrderId
left JOIN dbo.tblProgramType pt  with(nolock) ON mas.ProgramTypeId = pt.ProgramTypeId
left JOIN dbo.tblCustomerType ct  with(nolock) ON mas.CustTypeId = ct.CustomerTypeId
left JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId

--left JOIN tblCustMaster C  with(nolock) ON C.CustomerMasterId = mas.CustomerMasterId

left JOIN dbo.tblCompanyUnit CU  with(nolock) ON CU.ComUnitId = mas.ComUnitId
 --left JOIN dbo.[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType


LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 
	 
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
       where  I.InvoiceId IS NOT NULL