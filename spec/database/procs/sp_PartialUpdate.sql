Create PROCEDURE [dbo].[sp_PartialUpdate]
	-- Add the parameters for the stored procedure here
  
AS
BEGIN
		 
	DECLARE @OrderNo NVARCHAR(500)
DECLARE @TerritoryCode NVARCHAR(500)
DECLARE @AMCode datetime
DECLARE @ZoneCode datetime
DECLARE @TerritoryId NVARCHAR(500)
--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
SELECT 

    --ISNULL(SUM(id.PaymentNetAmount), 0) AS TotalPaymentNetAmount,
    --ISNULL(p.Payment, 0) AS TotalPaymentReceived,
    --i.PaymentStatus,
    --ISNULL(SUM(id.PaymentNetAmount), 0) - ISNULL(p.Payment, 0) AS BalanceDue,
    --i.InvoiceNo,
    i.InvoiceId
FROM 
    tblInvoice i
INNER JOIN 
    tblInvoiceDetail id ON i.InvoiceId = id.InvoiceId
LEFT JOIN 
    (
        SELECT 
            InvoiceId,
            SUM(TPAmount + VATAmount) AS Payment
        FROM 
            tblCustPayDetail
        GROUP BY 
            InvoiceId
    ) AS p ON p.InvoiceId = i.InvoiceId
WHERE 
    i.PaymentStatus = 'Full' and InvoiceDate between '1-july-2022' and '31-july-2029'
GROUP BY 
    i.PaymentStatus,
    i.InvoiceNo,
    i.InvoiceId,
    p.Payment,i.InvoiceDate
HAVING 
    ISNULL(SUM(id.PaymentNetAmount), 0) - ISNULL(p.Payment, 0) > 0 

----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@AMCode
WHILE @@FETCH_STATUS = 0
BEGIN

update tblInvoice set PaymentStatus='Partial' where InvoiceId=@AMCode

FETCH NEXT FROM @MyCursor
INTO 
@AMCode
END
CLOSE @MyCursor
DEALLOCATE @MyCursor


END
