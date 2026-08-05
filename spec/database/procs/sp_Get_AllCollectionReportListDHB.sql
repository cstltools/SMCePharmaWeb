CREATE PROCEDURE [dbo].[sp_Get_AllCollectionReportListDHB]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)=' select  tbl.TerritoryCode+'' : ''+tbl.TerritoryName_Ord TerritoryName,tbl.CustomerCode+'' : ''+tbl.CustomerName CustomerName, isnull(sum(TP_Pay),0) TotalNetPayable from (
		SELECT    mas.TerritoryCode,mas.TerritoryName_Ord, C.CustomerCode,C.CustomerName,
 
 sum((isnull(custDtl.TPAmount,0))) TP_Pay  
FROM tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I   ON I.InvoiceId = custDtl.InvoiceId
INNER JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
 
INNER JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
inner join (select InvoiceId,SUM(PaymentTotalPriceVatAmount)PaymentTotalPriceVatAmount,sum(PaymentTotalPrice)PaymentTotalPrice from tblInvoiceDetail group by InvoiceId)tblinvDetls on 
tblinvDetls.InvoiceId=I.InvoiceId
 
 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId
 

LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 
left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
 
where ((isnull(custDtl.PaymentAmount,0))) >0  and FinalPaymentNo is not null  and  I.PaymentStatus  IN (''Full'',''Partial'')    ' +@Parm + @Parm2+  '    group by   tblinvDetls.PaymentTotalPrice,tblinvDetls.PaymentTotalPriceVatAmount,I.PaymentTpVat,I.FinalPaymentNo,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName, I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) ,I.InvoiceNo,I.FixedCustomer, CONVERT(VARCHAR,I.InvoiceDate,103)  ,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) , I.PaymentInvoiceNo , CONVERT(VARCHAR,I.PaymentDate,103) , ptt.ProgramTypeName  ,ct.CustomerType ,I.TpGrandTotal,TpTotal,I.PaymentTpTotal ,I. PaymentTpGrandTotal ,DZSM.EmpMasterCode , AM.EmpMasterCode , AM.EmpName   , MIO.EmpMasterCode  , MIO.EmpName   , mas.GroupCode_Ord ,mas.RegionCode_Ord ,mas.AreaCode_Ord  ,mas.TerritoryCode,mas.TerritoryName_Ord ,mas.SubTerritoryCode_Ord+'' : '' + mas.SubTerritoryName_Ord , mas.MarketCode_Ord ,  mas.MarketName_Ord ,rt.RouteName  )tbl
  group by  tbl.TerritoryCode,tbl.TerritoryName_Ord  ,tbl.CustomerCode,tbl.CustomerName


  order by tbl.TerritoryCode asc  '	
EXEC sp_executesql @Q

END
             



--                       and CU.ComUnitId='" + districtId.Trim() + "' and I.UpdateDate between '" + fromDate + "' and '" + toDate + "' 