

CREATE PROCEDURE [dbo].[sp_InsertCustPayDetail_DeleteLog]
    @Remarks NVARCHAR(500),
    @CustPayDetailId INT,
    @LoginName  NVARCHAR(500)
AS
BEGIN
    

    INSERT INTO tblCustPayDetail_DeleteLog
    (
        CustPayDetailId,
        InvoiceId,
        PaymentAmount,
        CustPayId,
        SubDeportInvoiceId,
        Discount,
        CashAccId,
        BankAccId,
        AIT,
        IsPosting,
        TransctionDetailId,
        CustPaymentDate,
        TPAmount,
        VATAmount,
        FristRow,
        SecondRow,
        [42WorkingRow],
        CollectionBy,
        DANameId,
        PreviousDANameId,
        TestIDnew,
        PreCollDate,
        Remarks ,DelDate,DelBy
    )
    SELECT
        CustPayDetailId,
        InvoiceId,
        PaymentAmount,
        CustPayId,
        SubDeportInvoiceId,
        Discount,
        CashAccId,
        BankAccId,
        AIT,
        IsPosting,
        TransctionDetailId,
        CustPaymentDate,
        TPAmount,
        VATAmount,
        FristRow,
        SecondRow,
        [42WorkingRow],
        CollectionBy,
        DANameId,
        PreviousDANameId,
        TestIDnew,
        PreCollDate,
        @Remarks, getdate(),@LoginName
    FROM tblCustPayDetail
    WHERE CustPayDetailId = @CustPayDetailId;

	declare @InvoiceId int=0
	SELECT 
       @InvoiceId= InvoiceId 
    FROM tblCustPayDetail
    WHERE CustPayDetailId = @CustPayDetailId;

	update tblInvoice set PaymentStatus='Partial' where InvoiceId=@InvoiceId

	Delete From tblCustPayDetail WHERE CustPayDetailId = @CustPayDetailId;
END

