
CREATE PROCEDURE [dbo].[sp_Get_NewReceiveableList]
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
   SELECT mas.TerritoryName_Ord TerritoryName, mas.paymenttype,I.UpdateDate UpdateDate,format(I.UpdateDate,''dd-MMM-yyyy'') SalesDate,mas.[CustomerMasterId] CustomerMasterIdNew, '''' as fromdate ,'''' as todate ,cus.CellNo,mas.ComUnitCode ComUnitCode, MIO.EmpMasterCode MainMIOCODE, MIO.EmpName MainMIONAME, typ.CustomerType as CustomerType, mas.AreaCode_Ord AMCode,
 mas.RegionCode_Ord  DZSMCode, tblDetails.TotalPriceVatAmount TradeDiscount,
  cc.TerritoryCode  Territory, tblDetails.DeliveryNetAmount AS  ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
  I.OrderNo, FORMAT(I.OrderDate, ''dd-MMM-yyyy'') OrderDate,I.InvoiceNo, FORMAT(I.InvoiceDate, ''dd-MMM-yyyy'') InvoiceDate,ISNULL(TD.TotalDelivery,0) AS NetAmount,
  tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,mas.MarketCode_Ord MarketCode, REPLACE(mas.MarketName_Ord, '','', '' '') MarketName,DATEDIFF(DAY,DATEADD(day, -1,convert(date,I.InvoiceDate)),convert(date,GETDATE())) IntransitDay,MIO.EmpMasterCode  as MainMIOCODE,MIO.EmpName  as 
  MainMIONAME,I.CustomerType as SpecialAmount ,case when I.SndReturnInvoiceNo is not null then  isnull(sndRTN.sndReturnNetAmount,0) else ISNULL(TD.TotalDelivery,0) end ReturnAmount,  ISNULL(P.PP,0) CustomerPaymentAmount ,  (case when   I.SndReturnInvoiceNo is not null then  isnull(sndRTN.sndReturnNetAmount,0) else  ISNULL(TD.TotalDelivery,0) end - ISNULL(P.PP,0)) AS   ReceivableTotalAmnt,case when   I.SndReturnInvoiceNo is not null then  isnull(sndRTN.sndReturnNetAmount,0) else ISNULL(tblDetails.NetAmount,0) end NetAmountForRecv 
   FROM dbo.tblInvoice I WITH(nolock)  INNER JOIN ( select InvoiceId, sum(DeliveryNetAmount)NetAmount, ((Sum(DeliveryTotalPrice)+Sum(DeliveryTotalPriceVatAmount))-Sum(DeliveryDiscountAmount))DeliveryNetAmount,Sum(NetAmount)UnitVatAmount,(Sum(DeliveryDiscountAmount))TotalPriceVatAmount 
    from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId 
 inner JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId LEFT JOIN tblOrder mas ON mas.OrderId = I.OrderId 
LEFT JOIN tblCustMaster cus ON mas.[CustomerMasterId] = cus.CustomerMasterId  left  JOIN tblCustomerType typ ON typ.CustomerTypeId = mas.CustTypeId 
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=cus.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1
LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn  GROUP BY InvoiceId) AS SndRTN ON I.InvoiceId= SndRTN.InvoiceId 
LEFT JOIN (SELECT InvoiceId,SUM(isnull(TPAmount,0)+isnull(VATAmount,0)) AS PP FROM tblCustPayDetail GROUP BY InvoiceId) AS P ON I.InvoiceId = P.InvoiceId 
LEFT JOIN (SELECT InvoiceId,SUM(PaymentNetAmount) AS TotalDelivery FROM tblInvoiceDetail AS IVD WITH(NOLOCK) GROUP BY InvoiceId) AS TD ON I.InvoiceId = TD.InvoiceId  
where   ISNULL(ISNULL( case when  I.SndReturnInvoiceNo is not null  then  isnull(sndRTN.sndReturnNetAmount,0) else ISNULL(TD.TotalDelivery,0) end,0) -  ISNULL(P.PP,0),0)>5 and ISNULL( case when I.SndReturnInvoiceNo is not null  then  isnull(sndRTN.sndReturnNetAmount,0) else ISNULL(TD.TotalDelivery,0) end,0) <>  ISNULL(P.PP,0)  '+@districtId  +' Order by   MIO.EmpMasterCode asc, DATEDIFF(DAY,DATEADD(day, -1,convert(date,I.InvoiceDate)), convert(date,GETDATE())) DESC '  


	EXEC sp_executesql @Q
END