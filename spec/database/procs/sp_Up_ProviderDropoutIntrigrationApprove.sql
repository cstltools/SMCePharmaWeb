CREATE PROCEDURE [dbo].[sp_Up_ProviderDropoutIntrigrationApprove]
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

      declare @mobileNo nvarchar(max)=''
      select @mobileNo=mobileNo from tblProviderDropoutIntrigration     WHERE providerIDropoutIntrigrationd = @providerIDropoutIntrigrationd

      update tblCustMaster set PreProgramIDD=ProgramTypeId where  CellNo=@mobileNo

      update tblCustMaster set ProgramTypeId=4 where  CellNo=@mobileNo


END
 
 