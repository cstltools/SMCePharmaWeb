-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DcWiseTerritoryMaster]
	-- Add the parameters for the stored procedure here
	@DcWiseTerritoryMasterId INT,
    @DCId  INT
           ,@GroupId  INT
           ,@RegionId  INT
           ,@AreaId  INT,
            @SubDepotId  INT=NULL,
	@EntryBy nvarchar(50)=NULL

 

AS
    BEGIN
	
      INSERT INTO [dbo].[tblDcWiseTerritoryMaster]
           ([DCId]
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[EntryBy]
           ,[EntryDate],SubDepotId
           )
     VALUES
           (@DCId 
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@EntryBy 
           ,GETDATE(),@SubDepotId )

SELECT SCOPE_IDENTITY()

END

