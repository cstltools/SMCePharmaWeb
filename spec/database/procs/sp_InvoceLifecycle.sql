-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_InvoceLifecycle]
	@fromDate DATETIME,
	@toDate DATETIME

AS
BEGIN
 SELECT 

--proforma
C.ComUnitName,I.InvoiceNo,I.InvoiceDate,I.TpTotal AS ProformaTpTotal ,I.ReceivableAmount AS ProformaNetTotal,

--Delivery
(I.UpdateDate) AS DeliveryDate,ISNULL(I.DeliveryTpTotal,0)DeliveryTpTotal , ISNULL(I.DeliveryTpGrandTotal,0)DeliveryNetTotal,

--Return
tblRet.RDate AS ReturnDate,ISNULL(tblRet.RTpTotal,0)ReturnTpTotal ,ISNULL(tblRet.RTpGrandTotal,0)ReturnNetTotal,

--ProformaAfterReturn

(TpTotal-ISNULL(tblRet.RTpTotal,0))AfterReturnProformaTpTotal ,(ReceivableAmount-ISNULL(tblRet.RTpGrandTotal,0))AfterReturnProformaProformaNetTotal


,I.AreaCode ,I.RegionCode ,I.DisCode ,

ISNULL(tblTra.IntransitDay,0)IntransitDay

FROM dbo.tblInvoice I

INNER JOIN tblCompanyUnit C ON C.ComUnitId = I.ComUnitId

LEFT JOIN (SELECT (UpdateDate) AS RDate,InvoiceNo,(TpTotal-DeliveryTpTotal)RTpTotal,(ReceivableAmount-DeliveryTpGrandTotal)RTpGrandTotal FROM dbo.tblInvoice WHERE DelivaryInvoiceNo IS NOT NULL)tblRet ON tblRet.InvoiceNo = I.InvoiceNo
LEFT JOIN (SELECT InvoiceNo ,DATEDIFF(DAY, InvoiceDate, GETDATE()) AS IntransitDay FROM dbo.tblInvoice WHERE DelivaryInvoiceNo IS  NULL)tblTra ON tblTra.InvoiceNo = I.InvoiceNo

--left join (select  STUFF( (SELECT ',' + RTRIM(PaymentDate),InvoiceId
--                              FROM tblCustPayDetail
--							  INNER JOIN dbo.tblCustomerPay ON tblCustomerPay.CustPayId = tblCustPayDetail.CustPayId
            
            
--               FOR XML PATH('')
--          ),1,1,'') AS 'StringData' )tblPayment on tblPayment.StringData=I.InvoiceId


WHERE  I.InvoiceDate between @fromDate and @toDate 




UNION ALL


SELECT 

--proforma
'SubDeport' AS ComUnitName,I.InvoiceNo,I.InvoiceDate,I.TpTotal AS ProformaTpTotal ,I.DeliveryTpGrandTotal AS ProformaNetTotal,

--Delivery
(I.UpdateDate) AS DeliveryDate,ISNULL(I.DeliveryTpTotal,0)DeliveryTpTotal , ISNULL(I.DeliveryTpGrandTotal,0)DeliveryNetTotal,

--Return
tblRet.RDate AS ReturnDate,ISNULL(tblRet.RTpTotal,0)ReturnTpTotal ,ISNULL(tblRet.RTpGrandTotal,0)ReturnNetTotal,

--ProformaAfterReturn

(TpTotal-ISNULL(tblRet.RTpTotal,0))AfterReturnProformaTpTotal ,(DeliveryTpGrandTotal-ISNULL(tblRet.RTpGrandTotal,0))AfterReturnProformaProformaNetTotal


,I.AreaCode ,I.RegionCode ,I.DisCode ,

ISNULL(tblTra.IntransitDay,0)IntransitDay

FROM dbo.tblSubInvoiceMaster I



LEFT JOIN (SELECT (UpdateDate) AS RDate,InvoiceNo,(TpTotal-DeliveryTpTotal)RTpTotal,(DeliveryTpGrandTotal-DeliveryTpGrandTotal)RTpGrandTotal FROM dbo.tblSubInvoiceMaster WHERE DelivaryInvoiceNo IS NOT NULL)tblRet ON tblRet.InvoiceNo = I.InvoiceNo
LEFT JOIN (SELECT InvoiceNo ,DATEDIFF(DAY, InvoiceDate, GETDATE()) AS IntransitDay FROM dbo.tblSubInvoiceMaster WHERE DelivaryInvoiceNo IS  NULL)tblTra ON tblTra.InvoiceNo = I.InvoiceNo


WHERE  I.InvoiceDate between @fromDate and @toDate 



END
