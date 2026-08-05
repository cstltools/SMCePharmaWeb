
CREATE PROCEDURE [dbo].[sp_DeleteArchiveOrderData]
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

    IF OBJECT_ID(N'dbo.tblOrderDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tblOrderDeleteArchive
        FROM dbo.tblOrder;
    END

    IF OBJECT_ID(N'dbo.tblOrderDetailDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tblOrderDetailDeleteArchive
        FROM dbo.tblOrderDetail;
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
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblOrderDetail')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblOrderDetailDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SELECT @SelectColumnList = STUFF((
        SELECT ',tblOrderDetail.' + QUOTENAME(targetColumn.name)
        FROM sys.columns targetColumn
        INNER JOIN sys.columns sourceColumn
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblOrderDetail')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblOrderDetailDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SET @HasIdentity = CASE
                           WHEN EXISTS
                           (
                               SELECT 1
                               FROM sys.identity_columns
                               WHERE object_id = OBJECT_ID(N'dbo.tblOrderDetailDeleteArchive')
                           )
                           THEN 1
                           ELSE 0
                       END;

    SET @ArchiveQuery = N'';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tblOrderDetailDeleteArchive ON;';
    END

    SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tblOrderDetailDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tblOrderDetail
INNER JOIN dbo.tblOrder
    ON dbo.tblOrderDetail.OrderId = dbo.tblOrder.OrderId
WHERE dbo.tblOrder.SubmissionDate >= @FromDateTime
  AND dbo.tblOrder.SubmissionDate < @ToDateTime;';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tblOrderDetailDeleteArchive OFF;';
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
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblOrder')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblOrderDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SELECT @SelectColumnList = STUFF((
        SELECT ',tblOrder.' + QUOTENAME(targetColumn.name)
        FROM sys.columns targetColumn
        INNER JOIN sys.columns sourceColumn
            ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblOrder')
           AND sourceColumn.name = targetColumn.name
        WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblOrderDeleteArchive')
        ORDER BY targetColumn.column_id
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SET @HasIdentity = CASE
                           WHEN EXISTS
                           (
                               SELECT 1
                               FROM sys.identity_columns
                               WHERE object_id = OBJECT_ID(N'dbo.tblOrderDeleteArchive')
                           )
                           THEN 1
                           ELSE 0
                       END;

    SET @ArchiveQuery = N'';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tblOrderDeleteArchive ON;';
    END

    SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tblOrderDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tblOrder
WHERE dbo.tblOrder.SubmissionDate >= @FromDateTime
  AND dbo.tblOrder.SubmissionDate < @ToDateTime;';

    IF @HasIdentity = 1
    BEGIN
        SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tblOrderDeleteArchive OFF;';
    END

    EXEC sp_executesql
        @ArchiveQuery,
        N'@FromDateTime DATETIME, @ToDateTime DATETIME',
        @FromDateTime = @FromDateTime,
        @ToDateTime = @ToDateTime;

    DELETE SalesDisDB_SMC_NEWDB_Dynamic..tblOrderDetail
    FROM SalesDisDB_SMC_NEWDB_Dynamic..tblOrderDetail
    INNER JOIN SalesDisDB_SMC_NEWDB_Dynamic..tblOrder
        ON SalesDisDB_SMC_NEWDB_Dynamic..tblOrderDetail.OrderId = SalesDisDB_SMC_NEWDB_Dynamic..tblOrder.OrderId
    WHERE SalesDisDB_SMC_NEWDB_Dynamic..tblOrder.SubmissionDate >= @FromDateTime
      AND SalesDisDB_SMC_NEWDB_Dynamic..tblOrder.SubmissionDate < @ToDateTime;

    DELETE FROM SalesDisDB_SMC_NEWDB_Dynamic..tblOrder
    WHERE SubmissionDate >= @FromDateTime
      AND SubmissionDate < @ToDateTime;
END
