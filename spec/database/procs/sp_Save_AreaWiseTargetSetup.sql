-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_AreaWiseTargetSetup]
	-- Add the parameters for the stored procedure here
	 
@AreaWTSetupId INT ,
@Year  INT NULL,
@Month  nvarchar(max) NULL,
@GroupId  INT NULL,
@AreaId INT NULL,
@TargetAmount  decimal(18,2) NULL,
@RegionId INT NULL,
@Amount  INT NULL,
@EntryBy  NVARCHAR(MAX) 

AS
BEGIN


IF(@AreaWTSetupId>0)
 BEGIN
   UPDATE tblAreaWiseTargetSetup SET Amount=@Amount, UpdateBy=@EntryBy, UpdateDate= GETDATE() WHERE AreaWTSetupId=@AreaWTSetupId
 END
ELSE

IF NOT EXISTS (select Year, Month, GroupId from tblAreaWiseTargetSetup where Year=@Year AND Month=@Month AND AreaId=@AreaId )
  BEGIN 

 INSERT INTO [dbo].[tblAreaWiseTargetSetup]
           ([Year]
           ,[Month]
           ,[GroupId]
           ,TargetAmount
		   ,RegionId
		   ,AreaId
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
		   ,@AreaId
		   ,@Amount
           ,@EntryBy
           ,GETDATE()
           )
 
 SELECT  SCOPE_IDENTITY()

 END
 ELSE
 RETURN 0

END


