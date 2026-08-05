-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Del_B2BDelete]
	
	@chalanId nvarchar(500)

AS
BEGIN

DECLARE @DCstoreID NVARCHAR(500)
DECLARE @Qty NVARCHAR(500)

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------

select DCStoreId,Quantity FROM dbo.tblChalanDetail WHERE ChalanId=@chalanId

----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@DCstoreID,@Qty

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @Qty_Now decimal(18,2) =0


SELECT @Qty_Now=StockQty FROM dbo.tblDCStore WHERE DCStoreId=@DCstoreID
update dbo.tblDCStore set StockQty=@Qty_Now + @Qty where   DCStoreId=@DCstoreID




FETCH NEXT FROM @MyCursor
INTO 

@DCstoreID,@Qty

END
CLOSE @MyCursor
DEALLOCATE @MyCursor



DELETE FROM dbo.tblChalanDetail WHERE ChalanId = @chalanId

END


--SELECT * FROM dbo.tblChalanInfo WHERE ChalanId=162 
--SELECT * FROM dbo.tblChalanDetail WHERE ChalanId=162 

--SELECT * FROM dbo.tblDCStore WHERE DCStoreId IN (9850,9919,9995)