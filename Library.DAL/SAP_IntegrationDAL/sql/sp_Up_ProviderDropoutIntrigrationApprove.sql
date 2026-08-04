IF OBJECT_ID('dbo.sp_Up_ProviderDropoutIntrigrationApprove', 'P') IS NULL
BEGIN
    EXEC('CREATE PROCEDURE dbo.sp_Up_ProviderDropoutIntrigrationApprove AS BEGIN SET NOCOUNT ON; SELECT 1; END');
END
GO

ALTER PROCEDURE dbo.sp_Up_ProviderDropoutIntrigrationApprove
    @providerIDropoutIntrigrationd BIGINT,
    @ApproveBy NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.tblProviderDropoutIntrigration
    SET
        IsApprove = 1,
        IsApproveBy = @ApproveBy,
        ApproveDate = SYSUTCDATETIME()
    WHERE providerIDropoutIntrigrationd = @providerIDropoutIntrigrationd
      AND ISNULL(IsApprove, 0) = 0;
END
GO
