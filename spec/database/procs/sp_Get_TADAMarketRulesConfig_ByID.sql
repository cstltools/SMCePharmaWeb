

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_TADAMarketRulesConfig_ByID]
	-- Add the parameters for the stored procedure here
	@TADAMarketRuleConfigId INT = 0
AS
BEGIN
   

 Select * from tbl_TADAMarketRulesConfig where TADAMarketRuleConfigId = @TADAMarketRuleConfigId

END


