-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_CRRR_WrongPayment] 

 
AS
BEGIN
	
	
SELECT * FROM tblInvoice WHERE InvoiceNo IN ('INV-BD57-000000575')
SELECT * FROM tblCustPayDetail WHERE InvoiceId = 88027


SELECT * FROM tblPaymentTranscationDetail WHERE  InvoiceId = 88027

UPDATE tblInvoice SET PaymentStatus = 'Partial' WHERE InvoiceNo IN ('INV-BD57-000000575')

DELETE FROM tblCustPayDetail WHERE CustPayDetailId = 90182
DELETE FROM tblCustomerPay WHERE CustPayId = 90185

DELETE FROM tblPaymentTranscationMaster WHERE CustPayId = 52088
DELETE FROM tblPaymentTranscationDetail WHERE CustPayDetailId = 52076

DELETE FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE VoucherMasterId = 206158
DELETE FROM ZAS_ACCDB..tblDebitCreditVoucherDetail WHERE VoucherMasterId = 206158


SELECT * FROM ZAS_ACCDB..tblDebitCreditVoucherMaster WHERE CustPayDetailId = 88027
	
END






