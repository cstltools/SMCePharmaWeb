
CREATE PROCEDURE [dbo].[sp_Webapi_GetCampaignCustomer]
	-- Add the parameters for the stored procedure here
@customerTypeId INT,
@customerId INT
AS
BEGIN
	
	SELECT * FROM dbo.GetCampaignCustomer(@customerTypeId) WHERE CustomerId=@customerId

END

