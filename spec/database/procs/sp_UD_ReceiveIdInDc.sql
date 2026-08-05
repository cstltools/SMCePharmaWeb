-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UD_ReceiveIdInDc] 

AS
BEGIN
	  
	--FOR Stock
	DECLARE @DcStoreId INT
	DECLARE @StockInTransfarId INT
	DECLARE @ChalanDetailsId INT

	DECLARE @TempReceiveId INT
	DECLARE @TempDCStoreId INT
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT DCStoreId,StockInTransfarId,ChalanDetailsId FROM dbo.tblDCStore WHERE TempReceiveId IS NULL

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @DcStoreId,@StockInTransfarId,@ChalanDetailsId
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	


	IF (@StockInTransfarId IS NOT NULL )
	  BEGIN
	  
	  	SELECT @TempReceiveId = CTRS.ReceiveId FROM dbo.tblDCStore AS DCS with(nolock)  
                 INNER JOIN tblStockInTransfar AS TNS ON TNS.StockInTransfarId = DCS.StockInTransfarId  
                 INNER JOIN tblCentralStore AS CTRS ON TNS.ReceiveId = CTRS.ReceiveId WHERE TNS.StockInTransfarId = @StockInTransfarId
	  	
	  END

	ELSE

	  BEGIN
	   
	   SELECT @TempReceiveId = CTRS.ReceiveId FROM tblChalanDetail AS CD
              LEFT JOIN tblDCStore AS DCS ON CD.DCStoreId = DCS.DCStoreId
              LEFT JOIN tblStockInTransfar AS TNS ON TNS.StockInTransfarId = DCS.StockInTransfarId
              LEFT JOIN tblCentralStore AS CTRS ON TNS.ReceiveId = CTRS.ReceiveId   WHERE CD.ChalanDetailsId = @ChalanDetailsId

			  IF (@TempReceiveId IS NULL )
	          BEGIN

			   SELECT DISTINCT  @TempDCStoreId = CD.DCStoreId FROM tblChalanInfo AS CL
			   LEFT JOIN tblChalanDetail AS CD ON CL.ChalanId  = Cl.ChalanId
               WHERE CD.ChalanDetailsId = @ChalanDetailsId

			   SELECT @TempReceiveId = TempReceiveId FROM tblDCStore WHERE DCStoreId = @TempDCStoreId

	          END
	  END


	  UPDATE tblDCStore SET TempReceiveId = @TempReceiveId WHERE DCStoreId = @DcStoreId
	
	FETCH NEXT FROM @MyCursor
	INTO @DcStoreId,@StockInTransfarId,@ChalanDetailsId 
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor    

END







