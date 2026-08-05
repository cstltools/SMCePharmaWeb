
--------------------------------------------------
-- PROCEDURE: sp_da_SAVE_ExpenseClaim_DA
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_da_SAVE_ExpenseClaim_DA]
    @ExpenseClaimID INT = 0,
    @ExpenseTypeId INT,
    @ExpenseDate DATETIME,
    @EmpInfoId INT,
    @Amount DECIMAL(18, 2),
    @Remarks NVARCHAR(MAX) = NULL,
    @IsFromApp BIT = 1,
    @Details dbo.ExpenseClaimDetailTableType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @SavedExpenseClaimID INT = ISNULL(@ExpenseClaimID, 0);
    DECLARE @DetailCount INT = 0;
    DECLARE @EntryBy NVARCHAR(50);

    IF ISNULL(@ExpenseClaimID, 0) < 0
    BEGIN
        SELECT 400 AS StatusCode, N'ExpenseClaimID cannot be negative.' AS [Message],
               0 AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF ISNULL(@ExpenseTypeId, 0) <= 0 OR ISNULL(@EmpInfoId, 0) <= 0
    BEGIN
        SELECT 400 AS StatusCode, N'ExpenseTypeId and EmpInfoId must be greater than 0.' AS [Message],
               0 AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF @ExpenseDate IS NULL
    BEGIN
        SELECT 400 AS StatusCode, N'ExpenseDate is required.' AS [Message],
               0 AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF ISNULL(@Amount, 0) < 0
    BEGIN
        SELECT 400 AS StatusCode, N'Amount cannot be negative.' AS [Message],
               0 AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM @Details WHERE ISNULL(ExpenseTypDetailsId, 0) <= 0)
    BEGIN
        SELECT 400 AS StatusCode, N'Every expense claim detail must have ExpenseTypDetailsId greater than 0.' AS [Message],
               0 AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.tbl_ExpenseTypeMaster WITH (NOLOCK)
        WHERE ExpenseTypeId = @ExpenseTypeId
          AND IsActive = 1
    )
    BEGIN
        SELECT 400 AS StatusCode, N'Expense type is not active.' AS [Message],
               0 AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    SELECT TOP (1)
        @EntryBy = CONVERT(NVARCHAR(50), UserId)
    FROM dbo.tblUser WITH (NOLOCK)
    WHERE EmpInfoId = @EmpInfoId;

    IF @EntryBy IS NULL
    BEGIN
        SELECT 400 AS StatusCode, N'Employee user was not found for EmpInfoId.' AS [Message],
               0 AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF @SavedExpenseClaimID > 0
       AND NOT EXISTS (SELECT 1 FROM dbo.tbl_ExpenseClaim WITH (NOLOCK) WHERE ExpenseClaimID = @SavedExpenseClaimID)
    BEGIN
        SELECT 404 AS StatusCode, N'Expense claim not found.' AS [Message],
               @SavedExpenseClaimID AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    IF EXISTS
    (
        SELECT 1
        FROM dbo.tbl_ExpenseClaim WITH (UPDLOCK, HOLDLOCK)
        WHERE EmpInfoId = @EmpInfoId
          
          AND CONVERT(DATE, ExpenseDate) = CONVERT(DATE, @ExpenseDate)
          AND ExpenseClaimID <> @SavedExpenseClaimID
          AND ApprovalStatus <> N'3' AND EntryDate >= DATEADD(MINUTE, -5, GETDATE()) 
    )
    BEGIN
        SELECT 400 AS StatusCode, N'Expense claim already exists for this employee, expense type and date.' AS [Message],
               @SavedExpenseClaimID AS ExpenseClaimID, @ExpenseTypeId AS ExpenseTypeId, @ExpenseDate AS ExpenseDate,
               @EmpInfoId AS EmpInfoId, @Amount AS Amount, @Remarks AS Remarks,
               @IsFromApp AS IsFromApp, 0 AS DetailCount;
        RETURN;
    END

    SELECT @DetailCount = COUNT(1)
    FROM @Details;

    IF @SavedExpenseClaimID > 0
    BEGIN
        INSERT INTO dbo.tbl_ExpenseClaimDetailsDel
        (
            ExpenseDetailId,
            ExpenseClaimID,
            ExpenseTypDetailsId,
            ValueText
        )
        SELECT
            ExpenseDetailId,
            ExpenseClaimID,
            ExpenseTypDetailsId,
            ValueText
        FROM dbo.tbl_ExpenseClaimDetails
        WHERE ExpenseClaimID = @SavedExpenseClaimID;

        DELETE FROM dbo.tbl_ExpenseClaimDetails
        WHERE ExpenseClaimID = @SavedExpenseClaimID;

        UPDATE dbo.tbl_ExpenseClaim
        SET ExpenseTypeId = @ExpenseTypeId,
            ExpenseDate = @ExpenseDate,
            EmpInfoId = @EmpInfoId,
            Amount = @Amount,
            Remarks = @Remarks,
            IsFromApp = @IsFromApp,
            UpdateBy = @EntryBy,
            UpdateDate = GETDATE()
        WHERE ExpenseClaimID = @SavedExpenseClaimID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.tbl_ExpenseClaim
        (
            ExpenseTypeId,
            ExpenseDate,
            EmpInfoId,
            Amount,
            Remarks,
            EntryBy,
            EntryDate,
            ApprovalStatus,
            IsFromApp
        )
        VALUES
        (
            @ExpenseTypeId,
            @ExpenseDate,
            @EmpInfoId,
            @Amount,
            @Remarks,
            @EntryBy,
            GETDATE(),
            N'0',
            @IsFromApp
        );

        SET @SavedExpenseClaimID = CONVERT(INT, SCOPE_IDENTITY());
    END

    INSERT INTO dbo.tbl_ExpenseClaimDetails
    (
        ExpenseClaimID,
        ExpenseTypDetailsId,
        ValueText
    )
    SELECT
        @SavedExpenseClaimID,
        ExpenseTypDetailsId,
        NULLIF(LTRIM(RTRIM(ValueText)), N'')
    FROM @Details;

    SELECT
        CASE WHEN ISNULL(@ExpenseClaimID, 0) > 0 THEN 200 ELSE 201 END AS StatusCode,
        CASE WHEN ISNULL(@ExpenseClaimID, 0) > 0 THEN N'Expense claim updated successfully.' ELSE N'Expense claim saved successfully.' END AS [Message],
        @SavedExpenseClaimID AS ExpenseClaimID,
        @ExpenseTypeId AS ExpenseTypeId,
        @ExpenseDate AS ExpenseDate,
        @EmpInfoId AS EmpInfoId,
        @Amount AS Amount,
        @Remarks AS Remarks,
        @IsFromApp AS IsFromApp,
        @DetailCount AS DetailCount;
END

