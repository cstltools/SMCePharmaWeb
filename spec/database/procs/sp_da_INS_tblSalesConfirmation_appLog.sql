
CREATE   PROCEDURE [dbo].[sp_da_INS_tblSalesConfirmation_appLog]
    @DaId INT,
    @ComUnitId INT,
    @RouteId INT,
    @InvoiceId INT,
    @ApprovalStatus NVARCHAR(50) = N'Pending',
    @ApproveBy INT = NULL,
    @Remarks NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ServerApproveDate DATETIME2(0) = GETDATE();

    INSERT INTO dbo.tblSalesConfirmation_appLog
    (
        DaId,
        ComUnitId,
        RouteId,
        InvoiceId,
        ApprovalStatus,
        ApproveDate,
        ApproveBy,
        Remarks
    )
    VALUES
    (
        @DaId,
        @ComUnitId,
        @RouteId,
        @InvoiceId,
        ISNULL(@ApprovalStatus, N'Pending'),
        @ServerApproveDate,
        @ApproveBy,
        @Remarks
    );
    declare @DACodeName nvarchar(50)=''
    select @DACodeName=DACode+' : '+Name from tblDAInfo where DAId= @DaId

    UPDATE dbo.tblInvoice
    SET DA_SalesConfirmStatus = ISNULL(@ApprovalStatus, N'Pending'), DA_SalesConfirmDate=GETDATE(), DA_SalesConfirmBy=@DACodeName
    WHERE InvoiceId = @InvoiceId;

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END
