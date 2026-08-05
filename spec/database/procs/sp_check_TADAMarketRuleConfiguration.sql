

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_TADAMarketRuleConfiguration]
	-- Add the parameters for the stored procedure here
	   @id INT =NULL,
	  @TourType INT =NULL,
	  @UserRoleID INT =NULL,
    @MarketId  INT =NULL,
	@IsRoleWise bit=NULL,
	@IsMarketWise bit=NULL
AS
BEGIN
		 IF(@IsRoleWise=1)
	  begin
	SELECT * FROM dbo.tbl_TADAMarketRulesConfig WHERE  TourType=@TourType AND   UserRoleID=@UserRoleID AND  TADAMarketRuleConfigId NOT IN ( @id)
	END
 IF(@IsMarketWise=1)
	  begin
	SELECT * FROM dbo.tbl_TADAMarketRulesConfig WHERE   TourType=@TourType AND   MarketId=@MarketId AND    TADAMarketRuleConfigId NOT IN ( @id)
	END
 
END



