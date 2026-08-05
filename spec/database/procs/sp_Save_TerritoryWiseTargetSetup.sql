-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_TerritoryWiseTargetSetup]
	-- Add the parameters for the stored procedure here
	 
@TerritoryWTSetupId INT ,
@Year  INT NULL,
@Month  nvarchar(max) NULL,
@GroupId  INT NULL,
@AreaId INT NULL,
@TerritoryId  INT NULL,
@TargetAmount  decimal(18,2) NULL,
@RegionId INT NULL,
@Amount  INT NULL,
@EntryBy  NVARCHAR(MAX) 

AS
BEGIN


IF(@TerritoryWTSetupId>0)
 BEGIN
   UPDATE tblTerritoryWiseTargetSetup SET Amount=@Amount, UpdateBy=@EntryBy, UpdateDate= GETDATE() WHERE TerritoryWTSetupId=@TerritoryWTSetupId
 END
ELSE

IF NOT EXISTS (select Year, Month, GroupId from tblTerritoryWiseTargetSetup where Year=@Year AND Month=@Month AND TerritoryId=@TerritoryId )
  BEGIN 

 INSERT INTO [dbo].tblTerritoryWiseTargetSetup
           ([Year]
           ,[Month]
           ,[GroupId]
           ,TargetAmount
		   ,RegionId
		   ,AreaId
		   ,TerritoryId
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
		   ,@AreaId,@TerritoryId
		   ,@Amount
           ,@EntryBy
           ,GETDATE()
           )
 
 SELECT  SCOPE_IDENTITY()

 END
 ELSE
 RETURN 0

END


