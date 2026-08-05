CREATE PROCEDURE [dbo].[sp_Get_ProviderDropoutIntrigrationList]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        providerIDropoutIntrigrationd,
     0   providerId,
      programName  programShortName,
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