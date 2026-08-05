
CREATE PROCEDURE [dbo].[sp_GET_CampaignNameFromOrderDetail]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN
 


	select distinct replace(ord.CampaignName,'''',' ') CampaignName     from tblOrderDetail ord  WITH (NOLOCK) 
	 
	  where ord.CampaignName<>''
	 

 END
