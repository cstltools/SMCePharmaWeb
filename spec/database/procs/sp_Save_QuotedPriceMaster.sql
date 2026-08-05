
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_QuotedPriceMaster]
	-- Add the parameters for the stored procedure here
	 @QuotedPriceMasterId  int  ,
       @Description  NVARCHAR(max) =Null ,
       @Policy  NVARCHAR(max) =Null ,
       @IsCustomerWise bit =Null ,
       @IsMarketWise  bit =Null ,
       @CustomerMasterId  int =Null ,
       @GroupId int =Null ,
       @RegionId int =Null ,
       @AreaId  int=Null ,
       @TerritoryId  int =Null ,
       @SubTerritoryId int =Null ,
       @MarketId  int =Null ,
       @ActiveFromDate  datetime =Null ,
       @ActiveToDate datetime =Null ,
       @EntryBy  int  =Null ,
       @EntryDate  datetime =Null 
AS
    BEGIN
	
      INSERT INTO [dbo].[tblQuotedPriceMaster]
           ([Description]
           ,[Policy]
           ,[IsCustomerWise]
           --,[IsMarketWise]
           ,[CustomerMasterId]
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId]
           ,[ActiveFromDate]
           ,[ActiveToDate]
           ,[EntryBy]
           ,[EntryDate]
            )
     VALUES
           (@Description 
           ,@Policy 
           ,@IsCustomerWise 
           --,@IsMarketWise 
           ,@CustomerMasterId 
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId 
           ,@ActiveFromDate 
           ,@ActiveToDate 
           ,@EntryBy 
           ,@EntryDate 
          )
SELECT SCOPE_IDENTITY()

END


