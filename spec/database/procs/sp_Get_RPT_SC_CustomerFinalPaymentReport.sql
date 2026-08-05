
CREATE PROCEDURE [dbo].[sp_Get_RPT_SC_CustomerFinalPaymentReport]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='SELECT  (isnull(custDtl.PaymentAmount,0)) CustPaymentAmount,  I.FinalPaymentNo,CONVERT(VARCHAR, custDtl.CustPaymentDate,103) FinalPaymentDate,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer, 
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate, I.PaymentInvoiceNo PaymentInvoiceNo, CONVERT(VARCHAR,I.PaymentDate,103) PaymentDate, 
 ptt.ProgramTypeName  as Type,ct.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.PaymentTpTotal DeliveryTpTotal,I. PaymentTpGrandTotal DeliveryTpGrandTotal,DZSM.EmpMasterCode DZSMEmpName, 
 AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName  , MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,mas.AreaCode_Ord  AreaName,mas.TerritoryCode,mas.TerritoryName_Ord TerritoryName,
 mas.SubTerritoryCode_Ord+'' : ''+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,  mas.MarketName_Ord MarketName,rt.RouteName  as soldQty 
FROM tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I   ON I.InvoiceId = custDtl.InvoiceId
INNER JOIN dbo.tblOrder mas ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt ON mas.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON mas.CusttypeId = ct.CustomerTypeId
 
INNER JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
 
 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = mas.ComUnitId
 

LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 
	 
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
 
where I.PaymentStatus  IN (''Full'',''Partial'')  and FinalPaymentNo is not null  ' +@Parm + @Parm2   
						
EXEC sp_executesql @Q

END
             



--                       and CU.ComUnitId='" + districtId.Trim() + "' and I.UpdateDate between '" + fromDate + "' and '" + toDate + "' 