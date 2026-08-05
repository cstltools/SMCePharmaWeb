-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_UserMarketDetail]
	-- Add the parameters for the stored procedure here
	 

@UserId  INT=NULL,
@GroupId  INT=NULL,
@RegionId  INT=NULL,
@AreaId  INT=NULL,
@TerritoryId  INT=NULL,
@SubTerritoryId  INT=NULL,
@MarketId  INT=NULL
AS
    BEGIN
	
    INSERT INTO [dbo].tbl_UserMarketDetail
           (UserId
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId])
     VALUES
           (@UserId
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId )

	DECLARE @id INT
	SELECT @id=SCOPE_IDENTITY()

	DECLARE @param NVARCHAR(MAX)=' WHERE '

	IF(@GroupId IS NOT NULL)
	BEGIN
	    SET @param=@param+' GroupId='+CONVERT(NVARCHAR(MAX),@GroupId)+' '
	END
	IF(@RegionId IS NOT NULL)
	BEGIN
	    SET @param=@param+' AND RegionId='+CONVERT(NVARCHAR(MAX),@RegionId)+' '
	END
	IF(@AreaId IS NOT NULL)
	BEGIN
	    SET @param=@param+' AND AreaId='+CONVERT(NVARCHAR(MAX),@AreaId)+' '
	END
	IF(@TerritoryId IS NOT NULL)
	BEGIN
	    SET @param=@param+' AND TerritoryId='+CONVERT(NVARCHAR(MAX),@TerritoryId)+' '
	END
	IF(@SubTerritoryId IS NOT NULL)
	BEGIN
	    SET @param=@param+' AND  SubTerritoryId='+CONVERT(NVARCHAR(MAX),@SubTerritoryId)+' '
	END
	IF(@MarketId IS NOT NULL)
	BEGIN
	    SET @param=@param+' AND MarketId='+CONVERT(NVARCHAR(MAX),@MarketId)+' '
	END

	DECLARE @q NVARCHAR(MAX)=''
	SET @q='INSERT INTO dbo.tblUserMarketExecss
(
    UserId,
    GroupId,
    RegionId,
    AreaId,
    TerritoryId,
    SubTerritoryId,
    MarketId,
    UserMarketDetailId
)
SELECT '''+CONVERT(NVARCHAR(MAX),@UserId)+''',GroupId,RegionId,AreaId,TerritoryId,SubTerritoryId,MarketId,'''+CONVERT(NVARCHAR(MAX),@id)+''' FROM dbo.View_webapi_FieldForce '
+@param

--DELETE FROM dbo.tblUserMarketExecss WHERE UserId=@UserId

 EXEC sys.sp_executesql @q


END

