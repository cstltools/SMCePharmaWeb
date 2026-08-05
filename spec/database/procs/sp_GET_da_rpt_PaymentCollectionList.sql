 
CREATE   PROCEDURE [dbo].[sp_GET_da_rpt_PaymentCollectionList]
	-- Add the parameters for the stored procedure here
	@ComUnitId int,
	@RouteId int,
	@daid int,
	@frmDate date,
	@toDate date




AS
BEGIN


SELECT  mas.paymenttype,    STUFF((SELECT ', ' +   FORMAT(custDtl.custPaymentDate,'dd-MMM-yyyy') FROM dbo.tblCustPayDetail custDtl     with (nolock)   WHERE custDtl.InvoiceId = I.InvoiceId
FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS custPaymentDates, '' 
AS InvPayNo,
case when isnull(sndRTN.sndReturnTotalPrice,0)>0 then isnull(sndRTN.sndReturnTotalPrice,0) else tblinvDetls.PaymentTotalPrice end Inv_TP , case when isnull(sndRTN.sndReturnTotalPriceVatAmount,0)>0 then isnull(sndRTN.sndReturnTotalPriceVatAmount,0) else  tblinvDetls.PaymentTotalPriceVatAmount end Inv_Vat,sum((isnull(custDtl.TPAmount,0))) +
sum((isnull(custDtl.VATAmount,0)))   TotalPay,
CASE WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)>0 THEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)
 WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)<0 THEN 0 ELSE 0
END as TP_Pay, CASE  WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)>0 THEN tblinvDetls.PaymentTotalPriceVatAmount 
ELSE 0 END as Vat_Pay,
 sum((isnull(custDtl.TPAmount,0))) PayTPAmount,sum((isnull(custDtl.VATAmount,0))) PayVATAmount,I.FinalPaymentNo,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer, 
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate, I.PaymentInvoiceNo PaymentInvoiceNo, CONVERT(VARCHAR,I.PaymentDate,103) PaymentDate, 
 ptt.ProgramTypeName  as Type,ct.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.PaymentTpTotal DeliveryTpTotal,I. PaymentTpGrandTotal DeliveryTpGrandTotal,DZSM.EmpMasterCode DZSMEmpName, 
 AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName  , MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,ddd.AreaCode  AreaName,cc.TerritoryCode,cc.TerritoryName TerritoryName,
 mas.SubTerritoryCode_Ord+' : '+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,  mas.MarketName_Ord MarketName,rt.RouteName  as soldQty 
FROM tblCustPayDetail custDtl   with(nolock)
inner JOIN dbo.tblInvoice I   with (nolock)    ON I.InvoiceId = custDtl.InvoiceId
LEFT JOIN dbo.tblOrder mas  with (nolock)   ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt  with (nolock)   ON mas.ProgramTypeId = ptt.ProgramTypeId
 LEFT JOIN tblCustomertype ct  with (nolock)   ON mas.CusttypeId = ct.CustomerTypeId
inner JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
LEFT join (select InvoiceId,SUM(PaymentTotalPriceVatAmount)PaymentTotalPriceVatAmount,sum(PaymentTotalPrice)PaymentTotalPrice from tblInvoiceDetail  with (nolock)   group by InvoiceId)tblinvDetls on tblinvDetls.InvoiceId=I.InvoiceId 
LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn  GROUP BY InvoiceId) AS SndRTN ON I.InvoiceId= SndRTN.InvoiceId 
LEFT JOIN dbo.tblCompanyUnit CU  with (nolock)   ON CU.ComUnitId = mas.ComUnitId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1
 LEFT JOIN tblRegion   with (nolock)  ON tblRegion.RegionId=ddd.RegionId and tblRegion.IsActive=1
left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
where   I.InvoiceId>0     and  mas.ComUnitId= @ComUnitId and  mas.DistributionRouteId= @RouteId  AND   CONVERT(date,custDtl.CustPaymentDate)   BETWEEN @frmDate and @toDate
 group by  isnull(sndRTN.sndReturnTotalPrice,0),  isnull(sndRTN.sndReturnTotalPriceVatAmount,0), mas.paymenttype,   I.InvoiceId,tblinvDetls.PaymentTotalPrice,tblinvDetls.PaymentTotalPriceVatAmount,I.PaymentTpVat,I.FinalPaymentNo,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName, I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) ,I.InvoiceNo,I.FixedCustomer, CONVERT(VARCHAR,I.InvoiceDate,103)  ,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) , I.PaymentInvoiceNo , CONVERT(VARCHAR,I.PaymentDate,103) , ptt.ProgramTypeName  ,ct.CustomerType ,I.TpGrandTotal,TpTotal,I.PaymentTpTotal ,I. PaymentTpGrandTotal ,DZSM.EmpMasterCode , AM.EmpMasterCode , AM.EmpName   , MIO.EmpMasterCode  , MIO.EmpName   , mas.GroupCode_Ord ,mas.RegionCode_Ord ,ddd.AreaCode  ,cc.TerritoryCode,cc.TerritoryName ,mas.SubTerritoryCode_Ord+' : ' + mas.SubTerritoryName_Ord , mas.MarketCode_Ord ,  mas.MarketName_Ord ,rt.RouteName

end
