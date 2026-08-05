
create PROCEDURE [dbo].[sp_DeleteArchiveInvoiceData]
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

    IF OBJECT_ID(N'dbo.tblInvoiceDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tblInvoiceDeleteArchive
        FROM dbo.tblInvoice;
    END

    IF OBJECT_ID(N'dbo.tblInvoiceDetailDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tblInvoiceDetailDeleteArchive
        FROM dbo.tblInvoiceDetail;
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
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblInvoiceDetail')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblInvoiceDetailDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SELECT @SelectColumnList = STUFF((
        SELECT ',tblInvoiceDetail.' + QUOTENAME(targetColumn.name)
        FROM sys.columns targetColumn
        INNER JOIN sys.columns sourceColumn
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblInvoiceDetail')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblInvoiceDetailDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SET @HasIdentity = CASE
                           WHEN EXISTS
                           (
                               SELECT 1
                               FROM sys.identity_columns
                               WHERE object_id = OBJECT_ID(N'dbo.tblInvoiceDetailDeleteArchive')
                           )
                           THEN 1
                           ELSE 0
                       END;

    SET @ArchiveQuery = N'';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tblInvoiceDetailDeleteArchive ON;';
    END

    SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tblInvoiceDetailDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tblInvoiceDetail
INNER JOIN dbo.tblInvoice
    ON dbo.tblInvoiceDetail.InvoiceId = dbo.tblInvoice.InvoiceId
WHERE dbo.tblInvoice.InvoiceDate >= @FromDateTime
  AND dbo.tblInvoice.InvoiceDate < @ToDateTime;';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tblInvoiceDetailDeleteArchive OFF;';
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
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblInvoice')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblInvoiceDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SELECT @SelectColumnList = STUFF((
        SELECT ',tblInvoice.' + QUOTENAME(targetColumn.name)
        FROM sys.columns targetColumn
        INNER JOIN sys.columns sourceColumn
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblInvoice')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblInvoiceDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SET @HasIdentity = CASE
                           WHEN EXISTS
                           (
                               SELECT 1
                               FROM sys.identity_columns
                               WHERE object_id = OBJECT_ID(N'dbo.tblInvoiceDeleteArchive')
                           )
                           THEN 1
                           ELSE 0
                       END;

    SET @ArchiveQuery = N'';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tblInvoiceDeleteArchive ON;';
    END

    SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tblInvoiceDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tblInvoice
WHERE dbo.tblInvoice.InvoiceDate >= @FromDateTime
  AND dbo.tblInvoice.InvoiceDate < @ToDateTime;';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tblInvoiceDeleteArchive OFF;';
    END

    EXEC sp_executesql
        @ArchiveQuery,
        N'@FromDateTime DATETIME, @ToDateTime DATETIME',
        @FromDateTime = @FromDateTime,
        @ToDateTime = @ToDateTime;

    DELETE SalesDisDB_SMC_NEWDB_Dynamic..tblInvoiceDetail
    FROM SalesDisDB_SMC_NEWDB_Dynamic..tblInvoiceDetail
    INNER JOIN SalesDisDB_SMC_NEWDB_Dynamic..tblInvoice
        ON SalesDisDB_SMC_NEWDB_Dynamic..tblInvoiceDetail.InvoiceId = SalesDisDB_SMC_NEWDB_Dynamic..tblInvoice.InvoiceId
    WHERE SalesDisDB_SMC_NEWDB_Dynamic..tblInvoice.InvoiceDate >= @FromDateTime
      AND SalesDisDB_SMC_NEWDB_Dynamic..tblInvoice.InvoiceDate < @ToDateTime;

    DELETE FROM SalesDisDB_SMC_NEWDB_Dynamic..tblInvoice
    WHERE InvoiceDate >= @FromDateTime
      AND InvoiceDate < @ToDateTime;
END
