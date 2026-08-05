-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TPMarketDetailList]
	-- Add the parameters for the stored procedure here
	@TourPlanId INT 
AS
BEGIN
	 
	SELECT   dtl.MarketId, cust.MarketCode,cust.MarketName  
        
             FROM dbo.tblTPMarketDetail dtl with (nolock)
			 left join dbo.tblMarket cust on dtl.MarketId=cust.MarketId

			  WHERE dtl.TourPlanId = @TourPlanId
END
 