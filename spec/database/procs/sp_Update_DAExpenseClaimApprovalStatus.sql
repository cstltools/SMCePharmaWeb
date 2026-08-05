
--------------------------------------------------
-- PROCEDURE: sp_Update_DAExpenseClaimApprovalStatus
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Update_DAExpenseClaimApprovalStatus
    @ExpenseClaimID INT,
    @ApprovalStatus NVARCHAR(20),
    @ApprovedBy INT = NULL,
    @UpdateBy NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NormalizedStatus NVARCHAR(20) = UPPER(LTRIM(RTRIM(ISNULL(@ApprovalStatus, N''))));
    DECLARE @StatusText NVARCHAR(20);
    DECLARE @UpdatedBy NVARCHAR(100) = NULLIF(LTRIM(RTRIM(ISNULL(@UpdateBy, N''))), N'');

    IF @ExpenseClaimID IS NULL OR @ExpenseClaimID <= 0
    BEGIN
        RAISERROR('ExpenseClaimID is required.', 16, 1);
        RETURN;
    END

    IF @NormalizedStatus NOT IN (N'APPROVED', N'DISAPPROVED')
    BEGIN
        RAISERROR('Invalid approval status.', 16, 1);
        RETURN;
    END

    SET @StatusText =
        CASE @NormalizedStatus
            WHEN N'APPROVED' THEN N'Approved'
            ELSE N'DisApproved'
        END;

    UPDATE dbo.tbl_ExpenseClaim
       SET ApprovalStatus = @StatusText,
           ApprovedBy = COALESCE(@ApprovedBy, ApprovedBy),
           ApprovedDate = GETDATE(),
           UpdateBy = COALESCE(@UpdatedBy, UpdateBy),
           UpdateDate = GETDATE()
     WHERE ExpenseClaimID = @ExpenseClaimID
       AND (ApprovalStatus = N'0' OR ApprovalStatus IS NULL OR ApprovalStatus = N'');

    SELECT @@ROWCOUNT AS AffectedRows;
END

