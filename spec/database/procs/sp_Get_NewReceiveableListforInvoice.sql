
create PROCEDURE [dbo].[sp_Get_NewReceiveableListforInvoice]
	-- Add the parameters for the stored procedure here
	@districtId nvarchar(max)=null,
	@fromDate  nvarchar(max)=null,
	@toDate  nvarchar(max)=null


AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)=''

    IF (@fromDate IS NULL OR LTRIM(RTRIM(@fromDate)) = '')
    BEGIN
        SET @fromDate = CONVERT(NVARCHAR(MAX), GETDATE(), 121)  -- ISO format
    END

    -- Check if @toDate is NULL or empty and set it to the current date
    IF (@toDate IS NULL OR LTRIM(RTRIM(@toDate)) = '')
    BEGIN
        SET @toDate = CONVERT(NVARCHAR(MAX), GETDATE(), 121)  -- ISO format
    END
   
   set @Q='
   SELECT mas.[CustomerMasterId] CustomerMasterIdNew, '''+@fromDate+''' as fromdate ,'''+@toDate+''' as todate , cus.CellNo, mas.ComUnitCode ComUnitCode, MIO.EmpMasterCode MainMIOCODE, MIO.EmpName MainMIONAME, typ.CustomerType as CustomerType, mas.AreaCode_Ord AMCode,
 mas.RegionCode_Ord  DZSMCode, tblDetails.TotalPriceVatAmount TradeDiscount,
  cc.TerritoryCode  Territory, '''' fromdate , '''' todate ,
  tblDetails.DeliveryNetAmount AS  ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
  I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ISNULL(TD.TotalDelivery,0) AS NetAmount,
  tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode 
  AS DistrictCode,mas.MarketCode_Ord MarketCode,mas. MarketName_Ord MarketName,DATEDIFF(DAY,DATEADD(day, -1,convert(date,I.InvoiceDate)), convert(date,GETDATE())) IntransitDay,MIO.EmpMasterCode  as MainMIOCODE,MIO.EmpName  as 
  MainMIONAME,I.CustomerType as SpecialAmount ,  ISNULL(tblDetails.NetAmount,0)ReturnAmount,  ISNULL(P.PP,0) CustomerPaymentAmount , ISNULL(ISNULL(TD.TotalDelivery,0) -  ISNULL(P.PP,0),0) ReceivableTotalAmnt, ISNULL(tblDetails.NetAmount,0)NetAmountForRecv




FROM dbo.tblInvoice I WITH(nolock) 

INNER JOIN ( select InvoiceId, sum(DeliveryNetAmount)NetAmount, ((Sum(DeliveryTotalPrice)+Sum(DeliveryTotalPriceVatAmount))-Sum(DeliveryDiscountAmount))DeliveryNetAmount,Sum(DeliveryTotalPriceVatAmount)UnitVatAmount,(Sum(DeliveryDiscountAmount))TotalPriceVatAmount 

from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId 

INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId 

INNER JOIN tblOrder mas ON mas.OrderId = I.OrderId 
INNER JOIN tblCustMaster cus ON mas.[CustomerMasterId] = cus.CustomerMasterId 

 left  JOIN tblCustomerType typ ON typ.CustomerTypeId = mas.CustTypeId 
  
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId

LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=cus.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1


LEFT JOIN (SELECT InvoiceId,SUM(isnull(TPAmount,0)+isnull(VATAmount,0)) AS PP FROM tblCustPayDetail GROUP BY InvoiceId) AS P ON I.InvoiceId = P.InvoiceId 
inner JOIN (SELECT InvoiceId,SUM(PaymentNetAmount) AS TotalDelivery FROM tblInvoiceDetail AS IVD WITH(NOLOCK) GROUP BY InvoiceId) AS TD ON I.InvoiceId = TD.InvoiceId 
 

where   ISNULL(ISNULL(TD.TotalDelivery,0) -  ISNULL(P.PP,0),0)>10 and ISNULL(TD.TotalDelivery,0) <>  ISNULL(P.PP,0)   '+@districtId  +' Order by CONVERT(VARCHAR,I.InvoiceDate,103) asc '  







	EXEC sp_executesql @Q
END

--(ISNULL(ISNULL(TD.TotalDelivery,0) -  ISNULL(P.PP,0),0) ) >0.09 and



  
            
-- union all 

-- SELECT  '''+@fromDate+''' as fromdate ,'''+@toDate+''' as todate ,'''' CellNo, CU.ComUnitCode,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as 
-- CustomerType,I.DisCode as AMCode,I.RegionCode  as DZSMCode,tblDetails.TotalPriceVatAmount  AS TradeDiscount,
-- I.AreaCode  as Territory,''-''  as fromdate,''-''  as todate,

--  tblDetails.NetAmount AS ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
--I.OrderNo,
-- CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,
--CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,tblDetails.NetAmount
-- AS NetAmount,tblDetails.UnitVatAmount AS 
-- TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,

--I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,
-- I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay

--,I.MIACode as MainMIOCODE,I.MIAName as 
--  MainMIONAME,I.CustomerType as SpecialAmount ,0 as ReturnAmount,  0 as CustomerPaymentAmount , tblDetails.NetAmount as  ReceivableTotalAmnt
 
--FROM SalesDisDB_SMC..tblInvoice I WITH(nolock) 
--INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)
--UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from SalesDisDB_SMC..tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId 
--INNER JOIN SalesDisDB_SMC..tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
--INNER JOIN SalesDisDB_SMC..View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
-- where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL  and  CONVERT(date,I.InvoiceDate)  BETWEEN '''+@fromDate+''' AND '''+@toDate+''' '

