CREATE PROCEDURE [dbo].[sp_Get_MIOWiseReceiveableReport]
	-- Add the parameters for the stored procedure here
 @Parm nvarchar(max),
 @FrmDate nvarchar(max),
 @ToDate nvarchar(max)

AS
BEGIN

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='
SELECT '''+@FrmDate+''' as fromdate ,'''+@ToDate+''' as todate ,C.Address as ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,ord.AreaCode_Ord AreaCode,ord.RegionCode_Ord as MiaCode,I.DisCode AS DistrictCode ,ord.MarketCode_Ord MarketCode,ord.MarketName_Ord MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount 

FROM dbo.tblInvoice I WITH(nolock) 
INNER JOIN ( select InvoiceId,SUM(NetAmount) NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId

 INNER JOIN tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
 INNER JOIN tblOrder ord ON ord.OrderId = I.OrderId 
  INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = ord.ComUnitId
 
 where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL  '+@Parm+' 



 ORDER BY DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) DESC'  

 EXEC sys.sp_executesql @Q


    END










--	union all

--SELECT '''+@FrmDate+''' as fromdate ,'''+@ToDate+''' as todate ,C.Address as ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount 

--FROM SalesDisDB_SMC..tblInvoice I WITH(nolock) 
--INNER JOIN ( select InvoiceId,SUM(NetAmount) NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))
--TotalPriceVatAmount from SalesDisDB_SMC..tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId

-- INNER JOIN SalesDisDB_SMC..tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 
-- INNER JOIN SalesDisDB_SMC..tblOrder ord ON ord.OrderId = I.OrderId 
--  INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = ord.ComUnitId
-- where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL   '+@Parm+'