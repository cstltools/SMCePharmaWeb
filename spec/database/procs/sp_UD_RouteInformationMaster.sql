
CREATE PROCEDURE [dbo].[sp_UD_RouteInformationMaster]
	-- Add the parameters for the stored procedure here
@RouteInformationMasterId INT,
	@DCId INT=null,

	@RouteName nvarchar(max),
	@IsSubDepo bit=null,
    @TotalDistance decimal(18,2),
    @TotalDay decimal(18,2) ,
    @entryBy INT ,
	 @RouteTypeId INT =NULL,
    @TAAmount DECIMAL(18,2) =NULL,
    @DAAmount  DECIMAL(18,2) =NULL

AS
    BEGIN

	UPDATE [dbo].[tblRouteInformationMaster]
   SET  DCId=@DCId, [RouteName] = @RouteName
      ,[TotalDistance] = @TotalDistance
      ,[TotalDay] = @TotalDay,
       IsSubDepo=@IsSubDepo
      ,[UpdateBy] = @entryBy
      ,[UpdateDate] = GETDATE(),RouteTypeId=@RouteTypeId,TAAmount=@TAAmount,DAAmount=@DAAmount
     
	WHERE  RouteInformationMasterId = @RouteInformationMasterId

	delete from tblRouteInformationMarketDetail  WHERE  RouteInformationMasterId = @RouteInformationMasterId

		delete from tblRouteInformationDADetail  WHERE  RouteInformationMasterId = @RouteInformationMasterId


		delete from tblRouteInformationWeekNameDetails  WHERE  RouteInformationMasterId = @RouteInformationMasterId

 END
