
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_MarketData]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @SubTerritoryId INT ,
    @Name NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @isActive BIT ,
    @acInAcDate DATETIME,
    @ThanaId INT 

AS
BEGIN

IF NOT EXISTS (select MarketName from tblMarket where MarketName = @Name and  SubTerritoryId=@SubTerritoryId)
    BEGIN 
				
         DECLARE @codeD NVARCHAR(MAX)

        SELECT  @codeD = 'MAR-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(MarketId)
                                                           + 10001 )) )
        FROM    dbo.tblMarket 


			INSERT INTO dbo.tblMarket
			        ( MarketCode ,
			          MarketName ,
			          SubTerritoryId ,
			          IsActive ,
			          acInAcDate ,
			          EntryBy ,
			          EntryDate ,ThanaId
			        )
			VALUES  ( 
					@codeD,
					@Name,
					@SubTerritoryId,
					@isActive,
					@acInAcDate,
					@createdBy,
					GETDATE(),@ThanaId
			        )


SELECT SCOPE_IDENTITY()
END
ELSE  	
		Return 0
    END