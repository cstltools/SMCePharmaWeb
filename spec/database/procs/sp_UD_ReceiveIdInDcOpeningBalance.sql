-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UD_ReceiveIdInDcOpeningBalance] 

AS
BEGIN
	  
	--FOR Stock
	DECLARE @DcStoreId INT
	DECLARE @TempReceiveId INT
	        
	--------------------------------------------------------
	DECLARE @MyCursor CURSOR
	SET @MyCursor = CURSOR FAST_FORWARD
	FOR
	---------------
	
	SELECT DCStoreId,TempReceiveId FROM dbo.tblDCStore WHERE TempReceiveId IS NOT NULL

	----------
	OPEN @MyCursor
	FETCH NEXT FROM @MyCursor
	INTO @DcStoreId,@TempReceiveId
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	

	  UPDATE tblDCStore_OpeningBalance SET TempReceiveId = @TempReceiveId WHERE DCStoreId = @DcStoreId
	
	FETCH NEXT FROM @MyCursor
	INTO @DcStoreId,@TempReceiveId 
	
	END
	CLOSE @MyCursor
	DEALLOCATE @MyCursor    

END




--SELECT TempReceiveId FROM tblDCStore WHERE DCStoreId = 9237




