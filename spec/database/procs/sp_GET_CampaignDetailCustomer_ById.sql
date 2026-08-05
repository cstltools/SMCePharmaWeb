

 create PROCEDURE [dbo].[sp_GET_CampaignDetailCustomer_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	select  dtl.CustomerMasterId, cus.CustomerCode+' : '+cus.CustomerName CustomerName    from tbl_BonusCampaignCustomerDetail dtl

	left join tblCustMaster cus on cus.CustomerMasterId=dtl.CustomerMasterId
	 
	 where CampaignMasterId= @id
      
    END


