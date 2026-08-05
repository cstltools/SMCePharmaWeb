
--STUFF((SELECT '', '' +   + ''P-''+cast(custDtl.CustPayDetailId as nvarchar(max))   
--FROM dbo.tblCustPayDetail custDtl     with (nolock)  WHERE custDtl.InvoiceId = I.InvoiceId FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 2, '''')
CREATE PROCEDURE [dbo].[sp_Get_RPT_SC_CustomerFinalPaymentReport_new]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)='' ,
	@Parm2 nvarchar(max)='' ,
	@oldParam nvarchar(max)='' 

AS
BEGIN
          SET NOCOUNT ON;

    DECLARE @Q NVARCHAR(MAX);

    SET @Q = N'SELECT  mas.paymenttype,  STUFF(( SELECT '', '' +    da.Name  FROM dbo.tblCustPayDetail custDtl    with (nolock)  
inner JOIN tblDAInfo da WITH (NOLOCK) ON da.DAId = custDtl.DANameId WHERE custDtl.InvoiceId = I.InvoiceId  ' +@Parm +'
FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 2, '''') AS DAName,STUFF((   SELECT '', '' +   custDtl.CollectionBy FROM dbo.tblCustPayDetail custDtl    with (nolock)  
WHERE custDtl.InvoiceId = I.InvoiceId  ' +@Parm +'FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 2, '''') AS CollectionBy,  STUFF((SELECT '', '' +   FORMAT(custDtl.custPaymentDate,''dd-MMM-yyyy'') FROM dbo.tblCustPayDetail custDtl     with (nolock)   WHERE custDtl.InvoiceId = I.InvoiceId
FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 2, '''') AS custPaymentDates, '''' 
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
 mas.SubTerritoryCode_Ord+'' : ''+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,  mas.MarketName_Ord MarketName,rt.RouteName  as soldQty 
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
left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
where   I.InvoiceId>0     ' +@Parm + @Parm2  +'
 group by  isnull(sndRTN.sndReturnTotalPrice,0),  isnull(sndRTN.sndReturnTotalPriceVatAmount,0), mas.paymenttype,   I.InvoiceId,tblinvDetls.PaymentTotalPrice,tblinvDetls.PaymentTotalPriceVatAmount,I.PaymentTpVat,I.FinalPaymentNo,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName, I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) ,I.InvoiceNo,I.FixedCustomer, CONVERT(VARCHAR,I.InvoiceDate,103)  ,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) , I.PaymentInvoiceNo , CONVERT(VARCHAR,I.PaymentDate,103) , ptt.ProgramTypeName  ,ct.CustomerType ,I.TpGrandTotal,TpTotal,I.PaymentTpTotal ,I. PaymentTpGrandTotal ,DZSM.EmpMasterCode , AM.EmpMasterCode , AM.EmpName   , MIO.EmpMasterCode  , MIO.EmpName   , mas.GroupCode_Ord ,mas.RegionCode_Ord ,ddd.AreaCode  ,cc.TerritoryCode,cc.TerritoryName ,mas.SubTerritoryCode_Ord+'' : '' + mas.SubTerritoryName_Ord , mas.MarketCode_Ord ,  mas.MarketName_Ord ,rt.RouteName '


    SELECT LEFT(@Q, 4000) AS Part1;
    SELECT SUBSTRING(@Q, 4001, 4000) AS Part2;
    SELECT SUBSTRING(@Q, 8001, 4000) AS Part3;
    SELECT SUBSTRING(@Q, 12001, 4000) AS Part4;
    SELECT SUBSTRING(@Q, 16001, 4000) AS Part5;
    EXEC sp_executesql @Q

END


-- +' 
-- union all 
-- SELECT '''' DAName, '''' CollectionBy,  CONVERT(VARCHAR,I.UpdateDate,103) custPaymentDates, tbldetails.DeliveryNetAmount- tbldetails.Vat Inv_TP, tbldetails.Vat Inv_Vat,tbldetails.DeliveryNetAmount as TotalPay ,tbldetails.DeliveryNetAmount TP_Pay, tbldetails.Vat Vat_Pay,tbldetails.DeliveryNetAmount- tbldetails.Vat as PayTPAmount, tbldetails.Vat PayVATAmount,
--  I.DelivaryInvoiceNo FinalPaymentNo,'''' as SMCType_Ord,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,
--CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,
--CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,'''' as PaymentInvoiceNo, '''' as PaymentDate, 
--I.Types as Type,I.CustomerType as NewType,0 as TpGrandTotal,0 as TpTotal,0 as  DeliveryTpTotal,0 as   DeliveryTpGrandTotal,
--I.RegionCode as DZSMEmpName, I.DisCode AMEmpCode , '''' AMEmpName,  I.MiAcode  MIOEmpCode, I.MiaNAme MIOEmpName, '''' as GroupName,I.RegionCode as RegionName,
--I.DisCode  as AreaName,I.AreaCode    as TerritoryCode,
--I.AreaCode    as   TerritoryName,'''' as SubTerritoryName,I.MarketCode, I.MarketName as MarketName,'''' as soldQty
--FROM SalesDisDB_SMC..tblInvoice I  with(nolock)
--INNER JOIN (select InvoiceId,sum(DeliveryNetAmount)DeliveryNetAmount,sum(DeliveryNetAmount)-sum(DeliveryTotalPrice) as Vat from SalesDisDB_SMC..tblInvoiceDetail D  with (nolock)   group by InvoiceId )tbldetails  on tbldetails.InvoiceId=I.InvoiceId
--INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU  with (nolock)   ON CU.ComUnitId = I.ComUnitId INNER JOIN SalesDisDB_SMC..tblCustMaster C  with (nolock)   ON C.CustomerMasterId = I.CustomerMasterId where  I.UpdateDate is not null '+@oldParam