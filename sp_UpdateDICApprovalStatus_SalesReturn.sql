ALTER TABLE dbo.tblSalesReturn_appLog ADD DICApprovalStatus VARCHAR(50);
ALTER TABLE dbo.tblSalesReturn_appLog ADD DICApproveDate DATETIME;
ALTER TABLE dbo.tblSalesReturn_appLog ADD DICApproveBy VARCHAR(50);
GO

CREATE PROCEDURE [dbo].[sp_UpdateDICApprovalStatus_SalesReturn]
    @SalesReturnAppLogId VARCHAR(50),
    @DICApprovalStatus VARCHAR(50),
    @DICApproveDate DATETIME,
    @DICApproveBy VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.tblSalesReturn_appLog
    SET 
        DICApprovalStatus = @DICApprovalStatus,
        DICApproveDate = @DICApproveDate,
        DICApproveBy = @DICApproveBy
    WHERE 
        SalesReturnAppLogId = @SalesReturnAppLogId;
END
GO
