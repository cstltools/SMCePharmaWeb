create PROCEDURE [dbo].[sp_Webapi_CheckFakeMarket]
  
  @Marketd int
 as
 
BEGIN

	 select * from [dbo].[tblMarketFake] where Marketd=@Marketd

END