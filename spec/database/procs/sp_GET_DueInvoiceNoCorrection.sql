-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_DueInvoiceNoCorrection] 



AS
BEGIN
	
DECLARE @InvoiceId INT
DECLARE @InvoiceNo NVARCHAR(50)

DECLARE @ColumnId INT
DECLARE @Data NVARCHAR(100)

DECLARE @CountData INT
DECLARE @Date NVARCHAR(MAX)
   
--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------

SELECT InvoiceId,InvoiceNo FROM tblInvoice WHERE Remarks IN ('Due') AND InvoiceNo LIKE 'I%'
	
----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO @InvoiceId,@InvoiceNo

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @SplitData CURSOR 
SET @SplitData = CURSOR FAST_FORWARD
FOR
--Select Name ,Mobile from  My_table (Nolock)
SELECT  column_id,value	 FROM fn_split_string_to_column(@InvoiceNo,'-')
 
OPEN @SplitData
FETCH NEXT FROM @SplitData 
INTO @ColumnId,@Data
WHILE @@FETCH_STATUS = 0
BEGIN

SELECT  @CountData=COUNT(*)	 FROM fn_split_string_to_column(@InvoiceNo,'-')

IF(@CountData>2)
BEGIN
    
	IF(@ColumnId=1)
	BEGIN
	    
		SET @Date = 'D-' + @Data + '- '
	END
	IF(@ColumnId=2)
	BEGIN
	    
		SET @Date = @Date + @Data + '-'
	END
	IF(@ColumnId=3)
	BEGIN
		SET @Date = @Date + @Data
	END
END


FETCH NEXT FROM @SplitData 
INTO @ColumnId,@Data
END
CLOSE @SplitData
DEALLOCATE @SplitData

UPDATE dbo.tblInvoice SET InvoiceNo = @InvoiceNo WHERE InvoiceId = @InvoiceId

FETCH NEXT FROM @MyCursor
INTO @InvoiceId,@InvoiceNo

END
CLOSE @MyCursor
DEALLOCATE @MyCursor
	
END


--SELECT * FROM dbo.tblCustomerCreditLimit
--INNER JOIN dbo.tblCustMaster ON tblCustMaster.CustomerMasterId = tblCustomerCreditLimit.CustomerMasterId
--WHERE CustomerCode IN ('17686')


