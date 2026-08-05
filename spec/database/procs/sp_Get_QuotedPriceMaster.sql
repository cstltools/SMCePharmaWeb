-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_QuotedPriceMaster]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
select cus.CustomerCode +' : '+cus.CustomerName CustomerName, case when IsCustomerWise=1 then 'Yes' else 'No' end CustomerWise,'' MarketWise,  * from tblQuotedPriceMaster pro with (nolock)
left join tblCustMaster cus on  cus.CustomerMasterId= pro.CustomerMasterId
  
END


