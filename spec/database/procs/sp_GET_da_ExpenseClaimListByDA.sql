
CREATE   PROCEDURE dbo.sp_GET_da_ExpenseClaimListByDA
    @daid INT,
    @month INT,
    @year INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDate DATE = DATEFROMPARTS(@year, @month, 1);
    DECLARE @ToDate DATE = DATEADD(MONTH, 1, @FromDate);

    SELECT
        EC.ExpenseClaimID,
        EC.ExpenseTypeId,
        ISNULL(ET.ExpenseTypeName, '') AS ExpenseTypeName,
        CONVERT(VARCHAR(10), EC.ExpenseDate, 23) AS ExpDate,
        EC.EmpInfoId,
        ISNULL(EC.Amount, 0) AS Amount,
        ISNULL(EC.Remarks, '') AS Remarks,
        ISNULL(EC.ApprovalStatus, '') AS ApprovalStatus,
        CAST(ISNULL(EC.IsFromApp, 0) AS BIT) AS IsFromApp,
        ISNULL(EC.ImageName, '') AS ImageName,
        ISNULL(EC.ImagePath, '') AS ImagePath,
        ISNULL(EC.EntryBy, '') AS EntryBy,
        ISNULL(CONVERT(VARCHAR(19), EC.EntryDate, 120), '') AS EntryDate,
        ISNULL(EC.UpdateBy, '') AS UpdateBy,
        ISNULL(CONVERT(VARCHAR(19), EC.UpdateDate, 120), '') AS UpdateDate
    FROM dbo.tbl_ExpenseClaim EC WITH (NOLOCK)
    LEFT JOIN dbo.tbl_ExpenseTypeMaster ET WITH (NOLOCK)
        ON ET.ExpenseTypeId = EC.ExpenseTypeId
    WHERE EC.EmpInfoId = @daid
      AND EC.ExpenseDate >= @FromDate
      AND EC.ExpenseDate < @ToDate
    ORDER BY EC.ExpenseDate DESC, EC.ExpenseClaimID DESC;

    DECLARE @detailSql NVARCHAR(MAX) = N'
    SELECT
        ECD.ExpenseDetailId,
        ECD.ExpenseClaimID,
        ECD.ExpenseTypDetailsId,
        ISNULL(ETD.FieldName, '''') AS FieldName,
        ISNULL(ECD.ValueText, '''') AS ValueText,
        CAST(ISNULL(ETD.IsRequied, 0) AS BIT) AS IsRequied,
        ' + CASE
                WHEN COL_LENGTH(N'dbo.tbl_ExpenseTypeDetails', N'ExpenseAmount') IS NOT NULL
                    THEN N'ISNULL(ETD.ExpenseAmount, 0)'
                ELSE N'CAST(0 AS DECIMAL(18, 2))'
            END + N' AS ExpenseAmount,
        ' + CASE
                WHEN COL_LENGTH(N'dbo.tbl_ExpenseTypeDetails', N'isFixed') IS NOT NULL
                    THEN N'CAST(ISNULL(ETD.isFixed, 0) AS BIT)'
                ELSE N'CAST(0 AS BIT)'
            END + N' AS IsFixed
    FROM dbo.tbl_ExpenseClaimDetails ECD WITH (NOLOCK)
    INNER JOIN dbo.tbl_ExpenseClaim EC WITH (NOLOCK)
        ON EC.ExpenseClaimID = ECD.ExpenseClaimID
    LEFT JOIN dbo.tbl_ExpenseTypeDetails ETD WITH (NOLOCK)
        ON ETD.ExpenseTypDetailsId = ECD.ExpenseTypDetailsId
    WHERE EC.EmpInfoId = @daid
      AND EC.ExpenseDate >= @FromDate
      AND EC.ExpenseDate < @ToDate
    ORDER BY ECD.ExpenseClaimID, ECD.ExpenseDetailId;';

    EXEC sys.sp_executesql
        @detailSql,
        N'@daid INT, @FromDate DATE, @ToDate DATE',
        @daid = @daid,
        @FromDate = @FromDate,
        @ToDate = @ToDate;
END
