CREATE PROCEDURE [dbo].[usp_CheckCampaignList]
    @CustomerTypeId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @activeCampaignCount INT = 0;
    DECLARE @campCount INT = 0;

    -- Count active campaigns for the customer type
    SELECT @activeCampaignCount = COUNT(1)
    FROM tbl_BonusCampaignNewMaster WITH (NOLOCK)
    WHERE CustomerTypeId = @CustomerTypeId
      AND GETDATE() BETWEEN FromDate AND ToDate and IsActive=1;

    IF (@activeCampaignCount > 0)
    BEGIN
        SELECT @campCount = ISNULL(COUNT(1), 0)
        FROM tblCustMasterCampNew WITH (NOLOCK);
    END
    ELSE
    BEGIN
        SET @campCount = 1;
    END

    -- Final result
    SELECT ISNULL(@campCount, 0) AS campCount;
END;
