CREATE PROCEDURE [dbo].[sp_GetMissingCustomerCount]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CountResult INT = 0;
    DECLARE @Result INT;

    DECLARE @MaxEntryBonusCampaign DATETIME;
    DECLARE @MaxEntryCustCampaign DATETIME;
    DECLARE @Result2 NVARCHAR(3);

    SELECT @MaxEntryBonusCampaign = MAX(EntryDate) FROM tbl_BonusCampaignNewMaster;
    SELECT @MaxEntryCustCampaign = MAX(EntryDate) FROM tblCustMasterCampNew;

    IF @MaxEntryCustCampaign < @MaxEntryBonusCampaign
        SET @Result2 = 'yes';
    ELSE
        SET @Result2 = 'no';
         

    SELECT @CountResult = COUNT(*)
    FROM (
        SELECT DISTINCT M.NormalizedCustomerCode
        FROM dbo.tblCustMaster AS M WITH (NOLOCK)
        WHERE M.CustomerCode IS NOT NULL
          AND M.IsActive = 1 
          AND M.ActionStatus = '2'
          AND M.CustomerTypeId IN (1,23,16)
        EXCEPT
        SELECT DISTINCT C.NormalizedCustomerCode
        FROM dbo.tblCustMasterCampNew AS C WITH (NOLOCK)
        WHERE C.CustomerCode IS NOT NULL
    ) X;

 
 

    DECLARE @DAId INT,
        @LoginName NVARCHAR(100);

DECLARE DA_CURSOR CURSOR FOR
SELECT da.DAId, us.LoginName
FROM tblDAInfo da
INNER JOIN tblUser us 
    ON da.DACode = us.LoginName
WHERE us.daInfoId IS NULL
AND us.UserType = 'DA ASSISTANCE';

OPEN DA_CURSOR;

FETCH NEXT FROM DA_CURSOR INTO @DAId, @LoginName;

WHILE @@FETCH_STATUS = 0
BEGIN

    UPDATE tblUser
    SET daInfoId = @DAId,
        EmpInfoId = NULL
    WHERE LoginName = @LoginName;

    FETCH NEXT FROM DA_CURSOR INTO @DAId, @LoginName;
END

CLOSE DA_CURSOR;
DEALLOCATE DA_CURSOR;



   SET @Result = CASE WHEN @CountResult = 233 THEN 0 ELSE @CountResult END;

    SELECT case when @Result2='yes' then 1 else @Result end AS MissingCustomerCount;



END
