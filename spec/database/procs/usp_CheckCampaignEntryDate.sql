CREATE PROCEDURE usp_CheckCampaignEntryDate
AS
BEGIN
    DECLARE @MaxEntryBonusCampaign DATETIME;
    DECLARE @MaxEntryCustCampaign DATETIME;
    DECLARE @Result NVARCHAR(3);

    SELECT @MaxEntryBonusCampaign = MAX(EntryDate) FROM tbl_BonusCampaignNewMaster;
    SELECT @MaxEntryCustCampaign = MAX(EntryDate) FROM tblCustMasterCampNew;

    IF @MaxEntryCustCampaign < @MaxEntryBonusCampaign
        SET @Result = 'yes';
    ELSE
        SET @Result = 'no';

    SELECT @Result AS Result;
END
