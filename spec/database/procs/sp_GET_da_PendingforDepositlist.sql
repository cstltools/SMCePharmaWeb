CREATE   PROCEDURE [dbo].[sp_GET_da_PendingforDepositlist]
	-- Add the parameters for the stored procedure here
	@ComUnitId int,
	@RouteId int,
	@daid int 




AS
BEGIN

SELECT    PLOG.PaymentCollectionAppLogId, ord.ComUnitId, INV.CustomerMasterId, PLOG.PayableAmount  PayableAmount_DA,
       CUST.MarketId,
       ORD.DistributionRouteId,
       INV.InvoiceId,
       CUST.CustomerCode,
       CUST.CustomerName,
       ORD.TerritoryName_Ord,
       ORD.DistributionRoute_Ord,
       INV.InvoiceNo,
       INV.InvoiceDate,
       PLOG.DaId AS DAId,
       ORD.TerritoryName_Ord,
       ORD.MarketName_Ord
       --,
       --PLOG.BankId,
       --  PAYBANK.DisplayBankName BankName,
       --CAST(CALC.TotalDelivery AS DECIMAL(18, 2)) AS TotalDelivery,
       --CAST(CALC.PreviousPay AS DECIMAL(18, 2)) AS PaymentAmount,
       --CAST(CALC.DueAmount AS DECIMAL(18, 2)) AS Due,
       --CAST(CASE
       --         WHEN CALC.DueAmount <= 0 THEN 0
       --         WHEN CALC.DueAmount <= CALC.VatDue THEN 0
       --         ELSE CALC.DueAmount - CALC.VatDue
       --     END AS DECIMAL(18, 2)) AS TP_Pay,
       --CAST(CASE
       --         WHEN CALC.DueAmount <= 0 THEN 0
       --         WHEN CALC.DueAmount <= CALC.VatDue THEN CALC.DueAmount
       --         ELSE CALC.VatDue
       --     END AS DECIMAL(18, 2)) AS Vat_Pay,
       --CAST(CALC.AdjustAmount AS DECIMAL(18, 2)) AS AdjustableAmount
FROM dbo.tblInvoice INV WITH (NOLOCK)
INNER JOIN dbo.tblOrder ORD WITH (NOLOCK)
        ON ORD.OrderId = INV.OrderId
INNER JOIN dbo.View_CustomerMaster CUST WITH (NOLOCK)
        ON CUST.CustomerMasterId = INV.CustomerMasterId

        INNER JOIN dbo.tblPaymentCollection_appLog PLOG WITH (NOLOCK)
        ON INV.InvoiceId = PLOG.InvoiceId  and PLOG.ApprovalStatus='pending'
 
LEFT JOIN dbo.tblDAInfo PAYDA WITH (NOLOCK)
       ON PAYDA.DAId = PLOG.DaId
LEFT JOIN dbo.tblBankInfo PAYBANK WITH (NOLOCK)
       ON PAYBANK.BankId = PLOG.BankId
LEFT JOIN (
    SELECT InvoiceId,
           SUM(ISNULL(PaymentAmount, 0)) AS DetailPaymentAmount,
           SUM(ISNULL(TPAmount, 0)) AS DetailTPAmount,
           SUM(ISNULL(VATAmount, 0)) AS DetailVATAmount
    FROM dbo.tblCustPayDetail WITH (NOLOCK)
    GROUP BY InvoiceId
) PAY
       ON PAY.InvoiceId = INV.InvoiceId
CROSS APPLY (
    SELECT ISNULL(INV.DeliveryTpGrandTotal, 0) AS TotalDelivery,
           ISNULL(INV.AdjustAmount, 0) AS AdjustAmount,
           ISNULL(INV.PaymentAmount, ISNULL(PAY.DetailPaymentAmount, 0)) AS PreviousPay,
           CASE
               WHEN ISNULL(INV.DeliveryTpGrandTotal, 0)
                    - ISNULL(INV.PaymentAmount, ISNULL(PAY.DetailPaymentAmount, 0))
                    - ISNULL(INV.AdjustAmount, 0) < 0 THEN 0
               ELSE ISNULL(INV.DeliveryTpGrandTotal, 0)
                    - ISNULL(INV.PaymentAmount, ISNULL(PAY.DetailPaymentAmount, 0))
                    - ISNULL(INV.AdjustAmount, 0)
           END AS DueAmount,
           CASE
               WHEN ISNULL(INV.DeliveryTpVat, 0) - ISNULL(PAY.DetailVATAmount, 0) < 0 THEN 0
               ELSE ISNULL(INV.DeliveryTpVat, 0) - ISNULL(PAY.DetailVATAmount, 0)
           END AS VatDue
) CALC
WHERE ISNULL(INV.DeliveryTpGrandTotal, 0) > 0
   AND CALC.DueAmount > 0
  AND ISNULL(INV.DeliveryInvoiceStatus, '') IN ('Full', 'Partial') 

  and    ord.ComUnitId= @ComUnitId and  ord.DistributionRouteId= @RouteId  AND CONVERT(date,PLOG.CreatedOn)  =CONVERT(date,GETDATE())  and isnull(isDepositEntryDone,0)=0
  end