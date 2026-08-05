
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_MarketStationDetail]
	-- Add the parameters for the stored procedure here
	 
 
	@MarketId INT= null  ,
	@StationTypeId INT= null  ,
    @UserRoleID INT = null  
	 

AS
    BEGIN
	
      INSERT INTO [dbo].[tblMarketStationDetail]
           ([MarketId]
           ,[StationTypeId]
           ,[UserRoleID])
     VALUES
           (@MarketId 
           ,@StationTypeId 
           ,@UserRoleID )

 

END


