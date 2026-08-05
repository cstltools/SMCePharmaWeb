CREATE PROCEDURE [dbo].[sp_Get_DeliveryReturnReport] 
	-- Add the parameters for the stored procedure here
   
    
  @Parm nvarchar(max)
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='SELECT mas.SMCType_Ord,  I.ComUnitId, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,pt. ProgramTypeName as ProgramType,ct.CustomerType as CustomerType,I.OrderNo,Convert(varchar,I.OrderDate,103) AS
 OrderDate,I.InvoiceNo,
Convert(varchar,I.InvoiceDate,103)	as InvoiceDate,I.DelivaryInvoiceNo,Convert(varchar,I.UpdateDate,103)	as UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,Convert(varchar,DS.ExpDate,103) as ExpDate,
(ID.Quantity-ID.DeliveryQuantity)ReturnQuantity,(ID.NetAmount-ID.DeliveryNetAmount)Amount,
(ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount)VatAmount
,mas.MarketCode_Ord MarketCode,mas.MarketName_Ord MarketName,
 mas.TerritoryCode AreaCode,MIO.EmpMasterCode  MiaCode,AM.EmpMasterCode as DistrictCode , DZSM.EmpMasterCode RegionCode,ReturnReason,
Convert(varchar,I.UpdateDate,103)	as ReturnDate,mas.AreaCode_Ord AreaCodeNew, mas.RegionCode_Ord RegionCodeNew  
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblOrder mas ON mas.OrderId = I.OrderId
left JOIN dbo.tblProgramType pt  with(nolock) ON mas.ProgramTypeId = pt.ProgramTypeId
left JOIN dbo.tblCustomerType ct  with(nolock) ON mas.CustTypeId = ct.CustomerTypeId
		 
	 
		LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId

INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
where  ID.DeliveryStatus IN (''Reject'',''Partial'') ' + @Parm 
--RejectionSts=''old'' and
+'
UNION ALL

--old
	
	SELECT '''' SMCType_Ord, I.ComUnitId, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.Types as Type,I.CustomerType as ProgramType,I.OrderNo,Convert(varchar,I.OrderDate,103) AS
 OrderDate,I.InvoiceNo,
Convert(varchar,I.InvoiceDate,103)	as InvoiceDate,I.DelivaryInvoiceNo,Convert(varchar,I.UpdateDate,103)	as UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,Convert(varchar,DS.ExpDate,103) as ExpDate,
(ID.Quantity-ID.DeliveryQuantity)ReturnQuantity,(ID.NetAmount-ID.DeliveryNetAmount)Amount,
(ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount)VatAmount
,I.MarketCode,I.MarketName,
I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,ReturnReason,
Convert(varchar,I.UpdateDate,103)	as ReturnDate  , ''-'' AreaCodeNew, ''-'' RegionCodeNew
FROM SalesDisDB_SMC..tblInvoice I with(nolock)
INNER JOIN SalesDisDB_SMC..tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN SalesDisDB_SMC..View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN SalesDisDB_SMC..tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
where ID.DeliveryStatus IN (''Reject'',''Partial'') ' + @Parm 
--AND  I.UpdateDate between '" + fromDate + "' and '" + toDate + "'



EXEC sp_executesql @Q

END
              