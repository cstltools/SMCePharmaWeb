

 CREATE PROCEDURE [dbo].[sp_GET_QuotedPriceMaster_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select  cus.CustomerCode+' : '+cus.CustomerName CustomerName, FORMAT(ActiveFromDate,'dd MMMM, yyyy') ActiveFromDate, FORMAT(ActiveToDate,'dd MMMM, yyyy') ActiveToDate, * from tblQuotedPriceMaster
	left join tblCustMaster cus on tblQuotedPriceMaster.CustomerMasterId=cus.CustomerMasterId
	 where QuotedPriceMasterId=@id
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate, 
      
    END


