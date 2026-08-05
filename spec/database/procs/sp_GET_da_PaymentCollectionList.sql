
--------------------------------------------------
-- PROCEDURE: sp_GET_da_PaymentCollectionList
--------------------------------------------------


CREATE   PROCEDURE [dbo].[sp_GET_da_PaymentCollectionList]
	-- Add the parameters for the stored procedure here
	@ComUnitId int,
	@RouteId int,
	@daid int
AS
BEGIN
  SET NOCOUNT ON;
  
  SELECT ord.ComUnitName distributionCenter,  ord.DistributionRoute_Ord  RouteName,  ord.ComUnitCode+':'+  ord.ComUnitName saleCenter, '' feName,   ord.CustomerType, ord.MIOCode, ord.MIOName, INV.InvoiceNo PaymentInvoiceNo,  ord.OrderCode OrderNo, ord.Remarks, FORMAT(ord.SubmissionDate,'dd-MMM-yyyy') OrderDate,  FORMAT(INV.PaymentDate,'dd-MMM-yyyy')  InvoiceDate ,ord.CustomerCode, ord.CustomerName, ord.OrderSenderName, ord.TerritoryName_Ord,   ord.MarketId,ord.DistributionRouteId,  ord.CustomerMasterId,  INV.InvoiceId, TotalDelivery   TotalDeliveryAmount, ISNULL(PP,0) PaymentAmount,  (   ISNULL(TotalDelivery,0)   - ISNULL(PP,0)) AS   PayableAmount,ISNULL(ReturnTotal,0) AdjustableAmount FROM tblInvoice AS INV WITH(NOLOCK)
inner join tblOrder ord with (nolock) on INV.OrderId=ord.OrderId

--INNER JOIN tblCustMaster C ON C.CustomerMasterId = ord.CustomerMasterId
LEFT JOIN (SELECT InvoiceId,isnull(SUM(TPAmount) +SUM(VATAmount),0) AS PP, SUM(TPAmount) AS TPAmount, SUM(VATAmount) AS VATAmount FROM tblCustPayDetail GROUP BY InvoiceId) AS P ON INV.InvoiceId = P.InvoiceId 
inner JOIN (SELECT InvoiceId,SUM(PaymentNetAmount) AS TotalDelivery FROM tblInvoiceDetail AS IVD WITH(NOLOCK) GROUP BY InvoiceId) AS TD ON INV.InvoiceId = TD.InvoiceId 
LEFT JOIN (SELECT InvoiceId,SUM(TPGrandTotal) ReturnTotal FROM tblReturnInvoice  GROUP BY InvoiceId) AS RTN ON INV.InvoiceId= RTN.InvoiceId

--LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn with (nolock)  GROUP BY InvoiceId) AS SndRTN ON INV.InvoiceId= SndRTN.InvoiceId

inner join (select InvoiceId,SUM(PaymentTotalPriceVatAmount)PaymentTotalPriceVatAmount,sum(PaymentTotalPrice)PaymentTotalPrice from tblInvoiceDetail with (nolock)  group by InvoiceId)tblinvDetls on 
tblinvDetls.InvoiceId=INV.InvoiceId
WHERE (ISNULL(TotalDelivery,0) - ISNULL(PP,0))>0 and PaymentInvoiceNo  IS NOT NULL  and  SndReturnInvoiceNo is     null  and  ord.ComUnitId= @ComUnitId and  ord.DistributionRouteId= @RouteId 
         --  AND LTRIM(RTRIM(ISNULL(DA_PaymentCollection, ''))) NOT IN ('Pending', 'Approved', 'Canceled')
		   
		   
  UNION ALL
 
  SELECT
      ord.ComUnitName distributionCenter,
      ord.DistributionRoute_Ord RouteName,
      ord.ComUnitCode+':'+ord.ComUnitName saleCenter,
      '' feName,
      ord.CustomerType,
      ord.MIOCode,
      ord.MIOName,
      INV.InvoiceNo PaymentInvoiceNo,
      ord.OrderCode OrderNo,
      ord.Remarks,
      FORMAT(ord.SubmissionDate,'dd-MMM-yyyy') OrderDate,
      FORMAT(INV.PaymentDate,'dd-MMM-yyyy') InvoiceDate,
      ord.CustomerCode,
      ord.CustomerName,
      ord.OrderSenderName,
      ord.TerritoryName_Ord,
      ord.MarketId,
      ord.DistributionRouteId,
      ord.CustomerMasterId,
      INV.InvoiceId,
      CASE WHEN ISNULL(SndRTN.sndReturnNetAmount,0) > 0
           THEN ISNULL(SndRTN.sndReturnNetAmount,0)
           ELSE TotalDelivery
      END TotalDeliveryAmount,
      ISNULL(PP,0) PaymentAmount,
      (CASE WHEN ISNULL(SndRTN.sndReturnNetAmount,0) > 0
            THEN ISNULL(SndRTN.sndReturnNetAmount,0)
            ELSE ISNULL(TotalDelivery,0)
       END - ISNULL(PP,0)) AS PayableAmount,
      ISNULL(ReturnTotal,0) AdjustableAmount
  FROM tblInvoice AS INV WITH(NOLOCK)
  INNER JOIN tblOrder ord WITH (NOLOCK) ON INV.OrderId = ord.OrderId
  LEFT JOIN (
      SELECT InvoiceId, SUM(PaymentAmount) AS PP,
             SUM(TPAmount) AS TPAmount, SUM(VATAmount) AS VATAmount
      FROM tblCustPayDetail
      GROUP BY InvoiceId
  ) AS P ON INV.InvoiceId = P.InvoiceId
  INNER JOIN (
      SELECT InvoiceId, SUM(PaymentNetAmount) AS TotalDelivery
      FROM tblInvoiceDetail AS IVD WITH(NOLOCK)
      GROUP BY InvoiceId
  ) AS TD ON INV.InvoiceId = TD.InvoiceId
  LEFT JOIN (
      SELECT InvoiceId, SUM(TPGrandTotal) ReturnTotal
      FROM tblReturnInvoice
      GROUP BY InvoiceId
  ) AS RTN ON INV.InvoiceId = RTN.InvoiceId
  LEFT JOIN (
      SELECT InvoiceId,
             SUM(sndReturnTotalPrice) sndReturnTotalPrice,
             SUM(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,
             SUM(sndReturnNetAmount) sndReturnNetAmount
      FROM tblInvoiceDetailReturn WITH (NOLOCK)
      GROUP BY InvoiceId
  ) AS SndRTN ON INV.InvoiceId = SndRTN.InvoiceId
  INNER JOIN (
      SELECT InvoiceId,
             SUM(PaymentTotalPriceVatAmount) PaymentTotalPriceVatAmount,
             SUM(PaymentTotalPrice) PaymentTotalPrice
      FROM tblInvoiceDetail WITH (NOLOCK)
      GROUP BY InvoiceId
  ) tblinvDetls ON tblinvDetls.InvoiceId = INV.InvoiceId
  WHERE (ISNULL(TotalDelivery,0) - ISNULL(PP,0)) > 0
    AND PaymentInvoiceNo IS NOT NULL
    AND SndReturnInvoiceNo IS NOT NULL
    AND ISNULL(SndRTN.sndReturnTotalPrice,0) <> 0
    AND ord.ComUnitId = @ComUnitId
    AND ord.DistributionRouteId = @RouteId
  --  AND LTRIM(RTRIM(ISNULL(DA_PaymentCollection, ''))) NOT IN ('Pending', 'Approved', 'Canceled')



end 
