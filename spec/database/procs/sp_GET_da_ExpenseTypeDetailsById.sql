
CREATE   PROCEDURE [dbo].[sp_GET_da_ExpenseTypeDetailsById]
    @ExpenseTypeId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX) = N'
    SELECT
        ExpenseTypDetailsId,
        m.ExpenseTypeId,
        FieldName,
        IsRequied,
        ' + CASE
                WHEN COL_LENGTH(N'dbo.tbl_ExpenseTypeDetails', N'ExpenseAmount') IS NOT NULL
                    THEN N'ISNULL(m.ExpenseAmount, 0)'
                ELSE N'CAST(0 AS DECIMAL(18, 2))'
            END + N' AS ExpenseAmount,
        ' + CASE
                WHEN COL_LENGTH(N'dbo.tbl_ExpenseTypeDetails', N'isFixed') IS NOT NULL
                    THEN N'CAST(ISNULL(m.isFixed, 0) AS BIT)'
                ELSE N'CAST(0 AS BIT)'
            END + N' AS isFixed
    FROM dbo.tbl_ExpenseTypeDetails m
    INNER JOIN dbo.tbl_ExpenseTypeMaster v
        ON m.ExpenseTypeId = v.ExpenseTypeId
    WHERE m.ExpenseTypeId = @ExpenseTypeId;';

    EXEC sys.sp_executesql @sql, N'@ExpenseTypeId INT', @ExpenseTypeId = @ExpenseTypeId;
END
