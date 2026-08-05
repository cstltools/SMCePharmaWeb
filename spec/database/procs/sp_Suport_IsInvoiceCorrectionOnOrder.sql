-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Suport_IsInvoiceCorrectionOnOrder] 

	
	
AS
BEGIN
	
	DECLARE @OrderId INT
        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT OrderId FROM tblOrder WHERE IsInvoice = 0 AND OrderId IN (SELECT OrderId FROM tblInvoice WHERE OrderId is not null)
		
	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @OrderId
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	
	UPDATE tblOrder SET IsInvoice = 1 WHERE OrderId = @OrderId
	
	
	
	FETCH NEXT FROM @MyCursor
	INTO @OrderId
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor




	
END







