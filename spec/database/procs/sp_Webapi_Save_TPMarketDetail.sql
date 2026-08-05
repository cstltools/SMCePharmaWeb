-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_TPMarketDetail]
	-- Add the parameters for the stored procedure here
@marketId INT,
@pk INT 
AS
BEGIN

 

		INSERT INTO dbo.tblTPMarketDetail
		        ( TourPlanId, MarketId)
		VALUES  (
				@pk,@marketId
		          )


END    




 








  
