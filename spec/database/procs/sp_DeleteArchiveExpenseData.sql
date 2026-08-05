
CREATE PROCEDURE [dbo].[sp_DeleteArchiveExpenseData]
    @FromDate DATETIME,
    @ToDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    SET ANSI_NULLS ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET QUOTED_IDENTIFIER ON;
    SET NUMERIC_ROUNDABORT OFF;

    IF OBJECT_ID(N'dbo.tbl_ExpenseClaimDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tbl_ExpenseClaimDeleteArchive
        FROM dbo.tbl_ExpenseClaim;
    END

    IF OBJECT_ID(N'dbo.tbl_ExpenseClaimDetailsDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tbl_ExpenseClaimDetailsDeleteArchive
        FROM dbo.tbl_ExpenseClaimDetails;
    END

    DECLARE @InsertColumnList NVARCHAR(MAX);
    DECLARE @SelectColumnList NVARCHAR(MAX);
    DECLARE @ArchiveQuery NVARCHAR(MAX);
    DECLARE @HasIdentity BIT;
    DECLARE @FromDateTime DATETIME;
    DECLARE @ToDateTime DATETIME;

    SET @FromDateTime = CONVERT(DATETIME, CONVERT(DATE, @FromDate));
    SET @ToDateTime = CONVERT(DATETIME, DATEADD(DAY, 1, CONVERT(DATE, @ToDate)));

    SELECT @InsertColumnList = STUFF((
        SELECT ',' + QUOTENAME(targetColumn.name)
        FROM sys.columns targetColumn
        INNER JOIN sys.columns sourceColumn
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaimDetails')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaimDetailsDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SELECT @SelectColumnList = STUFF((
        SELECT ',dtl.' + QUOTENAME(targetColumn.name)
        FROM sys.columns targetColumn
        INNER JOIN sys.columns sourceColumn
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaimDetails')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaimDetailsDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SET @HasIdentity = CASE
                           WHEN EXISTS
                           (
                               SELECT 1
                               FROM sys.identity_columns
                               WHERE object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaimDetailsDeleteArchive')
                           )
                           THEN 1
                           ELSE 0
                       END;

    SET @ArchiveQuery = N'';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tbl_ExpenseClaimDetailsDeleteArchive ON;';
    END

    SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tbl_ExpenseClaimDetailsDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tbl_ExpenseClaimDetails dtl
INNER JOIN dbo.tbl_ExpenseClaim mas
    ON dtl.ExpenseClaimID = mas.ExpenseClaimID
WHERE mas.EntryDate >= @FromDateTime
  AND mas.EntryDate < @ToDateTime;';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tbl_ExpenseClaimDetailsDeleteArchive OFF;';
    END

    EXEC sp_executesql
        @ArchiveQuery,
        N'@FromDateTime DATETIME, @ToDateTime DATETIME',
        @FromDateTime = @FromDateTime,
        @ToDateTime = @ToDateTime;

    SELECT @InsertColumnList = STUFF((
        SELECT ',' + QUOTENAME(targetColumn.name)
        FROM sys.columns targetColumn
        INNER JOIN sys.columns sourceColumn
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaim')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaimDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SELECT @SelectColumnList = STUFF((
        SELECT ',mas.' + QUOTENAME(targetColumn.name)
        FROM sys.columns targetColumn
        INNER JOIN sys.columns sourceColumn
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaim')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaimDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SET @HasIdentity = CASE
                           WHEN EXISTS
                           (
                               SELECT 1
                               FROM sys.identity_columns
                               WHERE object_id = OBJECT_ID(N'dbo.tbl_ExpenseClaimDeleteArchive')
                           )
                           THEN 1
                           ELSE 0
                       END;

    SET @ArchiveQuery = N'';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tbl_ExpenseClaimDeleteArchive ON;';
    END

    SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tbl_ExpenseClaimDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tbl_ExpenseClaim mas
WHERE mas.EntryDate >= @FromDateTime
  AND mas.EntryDate < @ToDateTime;';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tbl_ExpenseClaimDeleteArchive OFF;';
    END

    EXEC sp_executesql
        @ArchiveQuery,
        N'@FromDateTime DATETIME, @ToDateTime DATETIME',
        @FromDateTime = @FromDateTime,
        @ToDateTime = @ToDateTime;

    DELETE dtl
    FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_ExpenseClaimDetails dtl
    INNER JOIN SalesDisDB_SMC_NEWDB_Dynamic..tbl_ExpenseClaim mas
        ON dtl.ExpenseClaimID = mas.ExpenseClaimID
    WHERE mas.EntryDate >= @FromDateTime
      AND mas.EntryDate < @ToDateTime;

    DELETE FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_ExpenseClaim
    WHERE EntryDate >= @FromDateTime
      AND EntryDate < @ToDateTime;
END
