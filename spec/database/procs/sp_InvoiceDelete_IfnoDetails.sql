

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_InvoiceDelete_IfnoDetails] 
-- exec sp_InvoiceDelete_IfnoDetails


AS
  --DECLARE @ContractAmount decimal(18,2)
--DECLARE @SalesContractId NVARCHAR(500)
DECLARE @TerritoryCode NVARCHAR(500)
DECLARE @AreaCode NVARCHAR(500)
DECLARE @ZoneCode NVARCHAR(500)
DECLARE @MarketName NVARCHAR(500)
DECLARE @OrderNO NVARCHAR(500)

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
SELECT i.InvoiceId, OrderId
FROM tblInvoice i
LEFT JOIN tblInvoiceDetail d ON i.InvoiceId = d.InvoiceId
WHERE d.InvoiceId IS NULL and 
--i.InvoiceId not in (select InvoiceId from tblInvoiceDetail) and 
    i.InvoiceDate  = CONVERT(DATE, GETDATE())

----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@TerritoryCode,@AreaCode
WHILE @@FETCH_STATUS = 0
BEGIN

delete from tblInvoice where InvoiceId=@TerritoryCode
update tblOrder SET  IsInvoice=0    where OrderId=@AreaCode

FETCH NEXT FROM @MyCursor
INTO 
@TerritoryCode,@AreaCode
END
CLOSE @MyCursor
DEALLOCATE @MyCursor









   
