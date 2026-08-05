

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CS_GetSubMarket_ByMarketId_Active]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN	
		Select * from tbl_SubMarket where IsActive =1 And MarketId = @id
END



