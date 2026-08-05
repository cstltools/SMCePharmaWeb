-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_ZoneWiseTargetSetup]
	-- Add the parameters for the stored procedure here
	 
@ZoneWTSetupId INT ,
@Year  INT NUll,
@Month  nvarchar(max) NUll,
@GroupId  INT NUll,
@TargetAmount  decimal(18,2) NUll,
@RegionId INT NUll,
@Amount  decimal(18,2) NUll,
@EntryBy  NVARCHAR(MAX)

AS
BEGIN


IF(@ZoneWTSetupId>0)
 BEGIN 
   UPDATE tblZoneWiseTargetSetup SET Amount = @Amount , UpdateBy=@EntryBy, UpdateDate= GETDATE()  WHERE ZoneWTSetupId = @ZoneWTSetupId
 END
 ELSE

IF NOT EXISTS (select Year, Month, GroupId from tblZoneWiseTargetSetup where Year=@Year AND Month=@Month AND  RegionId=@RegionId )
  BEGIN 

   INSERT INTO [dbo].[tblZoneWiseTargetSetup]
           ([Year]
           ,[Month]
           ,[GroupId]
           ,TargetAmount
		   ,RegionId
		   ,Amount
           ,[EntryBy]
           ,[EntryDate] 
           )
     VALUES
           (
		    @Year
           ,@Month
           ,@GroupId
           ,@TargetAmount
		   ,@RegionId
		   ,@Amount
           ,@EntryBy
           ,GETDATE()
           )
 
    SELECT  SCOPE_IDENTITY()

 End
        ELSE  Return 0

END


