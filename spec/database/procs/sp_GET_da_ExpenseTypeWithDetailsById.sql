
--------------------------------------------------
-- PROCEDURE: sp_GET_da_ExpenseTypeWithDetailsById
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_GET_da_ExpenseTypeWithDetailsById]
    @ExpenseTypeId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ExpenseTypeId,
        ExpenseTypeName,
        ImageRequired,
        ISNULL(ExpenseAmount, 0) AS ExpenseAmount,
        ISNULL(isFixed, 0) AS isFixed
    FROM dbo.tbl_ExpenseTypeMaster
    WHERE ExpenseTypeId = @ExpenseTypeId and IsActive=1

    DECLARE @detailSql NVARCHAR(MAX) = N'
    SELECT
        ExpenseTypDetailsId,
        ExpenseTypeId,
        FieldName,
        IsRequied,
        ' + CASE
                WHEN COL_LENGTH(N'dbo.tbl_ExpenseTypeDetails', N'ExpenseAmount') IS NOT NULL
                    THEN N'ISNULL(ExpenseAmount, 0)'
                ELSE N'CAST(0 AS DECIMAL(18, 2))'
            END + N' AS ExpenseAmount,
        ' + CASE
                WHEN COL_LENGTH(N'dbo.tbl_ExpenseTypeDetails', N'isFixed') IS NOT NULL
                    THEN N'CAST(ISNULL(isFixed, 0) AS BIT)'
                ELSE N'CAST(0 AS BIT)'
            END + N' AS isFixed
    FROM dbo.tbl_ExpenseTypeDetails
    WHERE ExpenseTypeId = @ExpenseTypeId;';

    EXEC sys.sp_executesql @detailSql, N'@ExpenseTypeId INT', @ExpenseTypeId = @ExpenseTypeId;
END

