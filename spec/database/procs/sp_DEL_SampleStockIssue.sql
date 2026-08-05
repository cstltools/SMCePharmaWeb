-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_DEL_SampleStockIssue] 

  @IssueCode NVARCHAR(MAX)

AS
BEGIN
	
	DECLARE @IssueId INT
	DECLARE @DCStoreId INT
    Declare @Quantity DECIMAL(18,2) 

            
    --------------------------------------------------------
    DECLARE @MyCursor CURSOR
    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    ---------------

	SELECT IssueId,ST.DCStoreId,ST.Quantity FROM tblSampleIssue AS SI 
	LEFT JOIN tblSampleIssueTranscation AS ST ON SI.OrderId = ST.IssueId
	WHERE SI.OrderCode = @IssueCode 

    ----------
    OPEN @MyCursor
    FETCH NEXT FROM @MyCursor
    INTO @IssueId ,
       @DCStoreId ,
       @Quantity
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
    
	

	DECLARE @Stock INT
	SET @Stock = 0
	SELECT @Stock = StockQty FROM tblDCStore WHERE DCStoreId = @DCStoreId

	UPDATE tblDCStore SET StockQty = @Stock + ISNULL((@Quantity*-1),0) WHERE DCStoreId = @DCStoreId
	UPDATE tblSampleIssue SET ActionStatus = 'Deleted' WHERE OrderId = @IssueId
	
	
    FETCH NEXT FROM @MyCursor
    INTO @IssueId ,
       @DCStoreId ,
       @Quantity
    
    END
    CLOSE @MyCursor
    DEALLOCATE @MyCursor
	
END



--SELECT DCStoreId,StockQty FROM tblDCStore WHERE DCStoreId IN (6458,6452)






