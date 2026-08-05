
CREATE PROCEDURE [dbo].[sp_Save_RouteInformationMaster]
	
	-- Add the parameters for the stored procedure here

	@RouteInformationMasterId INT,
	@DCId INT=null,
	@IsSubDepo bit=null,

	@RouteName nvarchar(max),
    @TotalDistance decimal(18,2),
    @TotalDay decimal(18,2) ,
    @entryBy INT ,
    @RouteTypeId INT =NULL,
    @TAAmount DECIMAL(18,2) =NULL,
    @DAAmount  DECIMAL(18,2) =NULL


 AS
    BEGIN
	
	IF NOT EXISTS (select  RouteName  from tblRouteInformationMaster where RouteName = @RouteName)
    BEGIN 
        INSERT INTO [dbo].[tblRouteInformationMaster]
           ([RouteName]
           ,[TotalDistance]
           ,[TotalDay]
           ,[EntryBy]
           ,[EntryDate],RouteTypeId,TAAmount,DAAmount, DCId, IsSubDepo
           )
     VALUES
           (@RouteName 
           ,@TotalDistance 
           ,@TotalDay 
           ,@EntryBy 
           ,GETDATE(),@RouteTypeId,@TAAmount,@DAAmount,@DCId,@IsSubDepo
          )

		SELECT SCOPE_IDENTITY()
		END
		ELSE  	
		Return 0


    END
