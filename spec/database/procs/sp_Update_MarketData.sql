-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_MarketData]
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

        UPDATE  dbo.tblMarket
        SET     SubTerritoryId = @SubTerritoryId ,
                MarketName = @Name ,
                UpdateBy = @createdBy ,
                UpdateDate = GETDATE() ,
                IsActive = @isActive ,
                acInAcDate = @acInAcDate, ThanaId=@ThanaId
        WHERE   MarketId = @id

	delete from tblMarketStationDetail    WHERE   MarketId = @id
    END

