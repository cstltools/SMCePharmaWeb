
CREATE PROCEDURE [dbo].[sp_Save_RouterDetails]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @RouterMasterId INT,
    @TerritoryId INT ,
    @MarketId INT 

AS
    BEGIN
	
        INSERT INTO RouterDetails
           (
			RouterMasterId
			,TerritoryId
           ,MarketId           
           )
     VALUES
           (
		    @RouterMasterId,
			@TerritoryId,
			@MarketId		  
		   )

		SELECT SCOPE_IDENTITY()

    END
