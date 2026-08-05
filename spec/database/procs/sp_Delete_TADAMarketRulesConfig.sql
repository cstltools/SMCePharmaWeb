
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_TADAMarketRulesConfig]
	-- Add the parameters for the stored procedure here
    @TADAMarketRuleConfigId INT = 0
  
AS
    BEGIN

      
       Delete from tbl_TADAMarketRulesConfig where TADAMarketRuleConfigId = @TADAMarketRuleConfigId

    END


