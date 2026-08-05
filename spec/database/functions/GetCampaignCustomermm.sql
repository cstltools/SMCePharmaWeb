
create FUNCTION [dbo].[GetCampaignCustomermm]
(
    @CutstomerType INT
)
RETURNS TABLE 
AS
RETURN
(
    SELECT 
        tblCustMaster.CustomerMasterId AS CustomerId,
        CustomerCode,
        CampaignMasterId AS CampMasId
    FROM tbl_BonusCampaignCustomerDetail WITH (NOLOCK)
    LEFT JOIN dbo.tblCustMaster WITH (NOLOCK) 
        ON tblCustMaster.CustomerMasterId = tbl_BonusCampaignCustomerDetail.CustomerMasterId
    WHERE EXISTS (
        SELECT 1 
        FROM dbo.tbl_BonusCampaignNewMaster WITH (NOLOCK)
        WHERE CampgainMasterId = tbl_BonusCampaignCustomerDetail.CampaignMasterId
        AND CustomerTypeId = @CutstomerType
        AND GETDATE() BETWEEN FromDate AND Todate
    )
)





