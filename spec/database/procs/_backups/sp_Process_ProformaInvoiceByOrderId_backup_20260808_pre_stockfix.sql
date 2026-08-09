/*
============================================================================
 BACKUP SNAPSHOT — sp_Process_ProformaInvoiceByOrderId
 Captured: 2026-08-08, before applying the two-line stock-validation fix
 (missing @ErrorStat=1 on stock-exhausted BREAK; NULL-loophole in the
 order-level pre-check). Restore by running this file's CREATE PROCEDURE
 body as ALTER PROCEDURE against SalesDisDB_SMC_NEWDB if a rollback of the
 fix itself is ever needed.
 Server at capture time: TOWSIF\MSSQLSERVER2019 (local dev), DB: SalesDisDB_SMC_NEWDB
============================================================================
*/
/*
============================================================================
 FIX SCRIPT: sp_Process_ProformaInvoiceByOrderId
 Server: 192.168.10.193   DB: SalesDisDB_SMC_NEWDB
 Base: live procedure body extracted via OBJECT_DEFINITION() on 2026-07-25.
 Business logic (FEFO batch split, invoice/detail insert, column lists) is
 UNCHANGED. Only concurrency/transaction-safety fixes are added, each
 marked with "-- FIX #n" so the diff against the current live SP is easy
 to review before deploying.

 FIX #1  SET XACT_ABORT ON  -> guarantees an automatic ROLLBACK on any
         unhandled runtime error instead of silently continuing / partially
         committing (see audit report section 5).
 FIX #2  BEGIN TRY / CATCH wrapped around the whole transaction body ->
         any error now hits ROLLBACK + THROW instead of leaving the
         transaction in an undefined state.
 FIX #3  Locked re-entrancy check on tblOrder.IsInvoice right after the
         transaction starts -> prevents two near-simultaneous calls for the
         SAME OrderId from both passing and double-invoicing / double-
         deducting stock (see audit report section 4).
 FIX #4  WITH (UPDLOCK, ROWLOCK) added to the batch-picking SELECT TOP 1
         on tblDCStore -> the row is locked for the remainder of the
         transaction from the moment it's read, so a concurrent session
         can no longer read the same "before decrement" StockQty and make
         the same allocation decision (root cause of possible negative /
         over-deducted stock, see audit report section 4 & 6).

 Test in a non-production environment first. Back up the current
 definition before running:
   SELECT OBJECT_DEFINITION(OBJECT_ID('sp_Process_ProformaInvoiceByOrderId'));
============================================================================
*/

CREATE PROCEDURE [dbo].[sp_Process_ProformaInvoiceByOrderId]

 @OrderId INT,
 @UserId INT,
 @DANameId INT,
 @BatchNo1 NVARCHAR(MAX),
 @SAforSelectedSick INT = NULL

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;   -- FIX #1

DECLARE @NegativeQtyCount INT=0
DECLARE @CreditAmount DECIMAL(18,2)=0

SELECT @NegativeQtyCount=COUNT(*)  FROM (SELECT tblt.Qty,ProductId,SUM(Quantity)AS OrdQty FROM dbo.tblOrder
LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
LEFT JOIN (SELECT ProductCode,ComUnitId,SUM(StockQty)Qty FROM dbo.tblDCStore GROUP BY ProductCode,ComUnitId)
AS tblt ON tblt.ProductCode = tblOrderDetail.ProductCode AND tblt.ComUnitId = tblOrder.ComUnitId
WHERE  tblOrder.OrderId=@OrderId GROUP BY tblt.Qty,ProductId) AS tblt WHERE tblt.Qty-tblt.OrdQty<0

declare @CustId int

select @CustId=CustomerMasterId from tblOrder where OrderId=@OrderId

SELECT @CreditAmount=ISNULL(SUM(Amount),0) FROM [dbo].[tblReturnAmount] WHERE CustomerId=@CustId
Declare @ErrorStat bit=0

BEGIN TRY                                                            -- FIX #2

 begin TRANSACTION orderprocess

-- FIX #3: locked re-entrancy guard — stop a second concurrent call for the
-- same OrderId from proceeding while the first call's transaction is open.
IF EXISTS (SELECT 1 FROM dbo.tblOrder WITH (UPDLOCK, ROWLOCK) WHERE OrderId=@OrderId AND IsInvoice=1)
BEGIN
    ROLLBACK TRANSACTION orderprocess
    RETURN
END

IF(@NegativeQtyCount<1 AND @CreditAmount=0)
BEGIN



		   DECLARE @InvoiceId INT
           DECLARE @InvoiceNo NVARCHAR(MAX)
           DECLARE @InvoiceDate DATETIME
           DECLARE @OrderNo NVARCHAR(MAX)
           DECLARE @OrderDate DATETIME
           DECLARE @CustomerMasterId INT
           DECLARE @ComUnitId INT
           DECLARE @MiaId INT
           DECLARE @PaymentTypeId INT
           DECLARE @TpTotal DECIMAL(18,2)
           DECLARE @TpDiscount DECIMAL(18,2)
           DECLARE @TpVat DECIMAL(18,2)
           DECLARE @TpGrandTotal DECIMAL(18,2)
           DECLARE @TotalSpecialAmount DECIMAL(18,2)
           DECLARE @ProductOf
