CREATE PROCEDURE [dbo].[sp_UpdateDICApprovalStatus]
    @SalesConfirmationAppLogId VARCHAR(50),
    @DICApprovalStatus VARCHAR(50),
    @DICApproveDate DATETIME,
    @DICApproveBy VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.tblSalesConfirmation_appLog
    SET 
        DICApprovalStatus = @DICApprovalStatus,
        DICApproveDate = @DICApproveDate,
        DICApproveBy = @DICApproveBy
    WHERE 
        SalesConfirmationAppLogId = @SalesConfirmationAppLogId;
END
GO
