
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_QuotedPriceMaster]
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
        UPDATE  dbo.[tblQuotedPriceMaster]
        SET     
		        [Description]=@Description
           ,[Policy]=@Policy
           ,[IsCustomerWise]=@IsCustomerWise
           --,[IsMarketWise]
           ,[CustomerMasterId]=@CustomerMasterId
           ,[GroupId]=@GroupId
           ,[RegionId]=@RegionId
           ,[AreaId]=@AreaId
           ,[TerritoryId]=@TerritoryId
           ,[SubTerritoryId]=@SubTerritoryId
           ,[MarketId]=@MarketId
           ,[ActiveFromDate]=@ActiveFromDate
           ,[ActiveToDate]=@ActiveToDate,
         
                UpdateBy = @EntryBy,
                UpdateDate = GETDATE()                         
        WHERE   QuotedPriceMasterId = @QuotedPriceMasterId

		Delete from tblQuotedPriceDetail where QuotedPriceMasterId = @QuotedPriceMasterId
    END


