


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_MarketInfo]
	-- Add the parameters for the stored procedure here
	  @id  INT ,@SubTerritoryId int,
      @Name   NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblMarket WHERE MarketName=@Name AND MarketId NOT IN ( @id) and  SubTerritoryId=@SubTerritoryId

END




