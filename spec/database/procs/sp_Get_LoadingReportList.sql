
CREATE PROCEDURE [dbo].[sp_Get_LoadingReportList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max),
	@dtRange nvarchar(max)

AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='SELECT  '''' LOADINGREPORTNo, '''+@dtRange+''' TitleDate,  '''' DeliveryPerson,'''' VeichleNo, mas.MarketCode_Ord+'' : ''+mas.MarketName_Ord MarketName, CU.ComUnitName DEPOTName,10.00 UndeliverdInvoice,  ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, I.InvoiceNo InvoiceNo,  mas.TerritoryCode_Ord+'' : ''+mas.TerritoryName_Ord  TerritoryCode,(tblID.NetAmount) InvoiceValue,10.00 Collection, 0 UndeliverdInvoice,10.00  FullRejection,10.00  PartialRejection,'''' Remarks,
   case when LoadingSummaryStatus =''Full'' then ''Cash'' when LoadingSummaryStatus =''Full Dues'' then ''Full Dues'' when LoadingSummaryStatus =''Partial Dues'' then ''Partial Dues'' end InvoiceStatus
    , case when LoadingSummaryStatus =''Full'' then ''0'' when LoadingSummaryStatus =''Full Dues'' then I.TpGrandTotal when LoadingSummaryStatus =''Partial Dues'' then DeliveryTpGrandTotal end MarketDues
	, case when DelivaryInvoiceNo is not null then (tblID.DeliveryNetAmount) else 0 end CashCollection
FROM dbo.tblInvoice I with(nolock)
   INNER JOIN (SELECT  sum(NetAmount)NetAmount,sum(DeliveryNetAmount)DeliveryNetAmount,InvoiceId FROM tblInvoiceDetail GROUP BY InvoiceId    )tblID on tblID.InvoiceId=I.InvoiceId
left JOIN dbo.tblOrder mas  with(nolock) ON I.OrderId = mas.OrderId
left JOIN dbo.tblProgramType pt  with(nolock) ON mas.ProgramTypeId = pt.ProgramTypeId
left JOIN dbo.tblCustomerType ct  with(nolock) ON mas.CustTypeId = ct.CustomerTypeId
 
left JOIN tblCustMaster C  with(nolock) ON C.CustomerMasterId = mas.CustomerMasterId

left JOIN dbo.tblCompanyUnit CU  with(nolock) ON CU.ComUnitId = mas.ComUnitId
 

LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 
	 
	 
       where  I.InvoiceId IS NOT NULL    '+ @Parm    +'    order by I.InvoiceDate asc'
	   	


EXEC sp_executesql @Q

END
              