IF OBJECT_ID('dbo.sp_Get_ProviderDropoutIntrigrationList', 'P') IS NULL
BEGIN
    EXEC('CREATE PROCEDURE dbo.sp_Get_ProviderDropoutIntrigrationList AS BEGIN SET NOCOUNT ON; SELECT 1; END');
END
GO

ALTER PROCEDURE dbo.sp_Get_ProviderDropoutIntrigrationList
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        providerIDropoutIntrigrationd,
        providerId,
        programShortName,
        providerCode,
        providerName,
        mobileNo,
        nid,
        email,
        outlet,
        dropoutReason,
        insertedAt,
        ISNULL(IsApprove, 0) AS IsApprove,
        IsApproveBy,
        ApproveDate
    FROM dbo.tblProviderDropoutIntrigration
    ORDER BY insertedAt DESC, providerIDropoutIntrigrationd DESC;
END
GO
