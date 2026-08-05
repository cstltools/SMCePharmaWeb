CREATE PROCEDURE [dbo].[sp_da_UPD_PaymentCollection_BankDeposit]
    @PaymentCollectionAppLogIds NVARCHAR(MAX),
    @BankId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- STRING_SPLIT ফাংশন দিয়ে কমা (,) দ্বারা আলাদা করা আইডিগুলোকে ভেঙে আপডেট করা হবে
    UPDATE tblPaymentCollection_appLog
    SET BankId = @BankId,DepositEntryDate=GETDATE(),isDepositEntryDone=1
    WHERE PaymentCollectionAppLogId IN ( select item from fnSplit ( @PaymentCollectionAppLogIds,',' ))
    
END
