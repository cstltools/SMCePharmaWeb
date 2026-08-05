
create PROCEDURE [dbo].[sp_DeleteArchiveRxData]
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

    IF OBJECT_ID(N'dbo.tbl_PrescriptionMasterDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tbl_PrescriptionMasterDeleteArchive
        FROM dbo.tbl_PrescriptionMaster;
    END

    IF OBJECT_ID(N'dbo.tbl_PrescriptionProductDetailDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tbl_PrescriptionProductDetailDeleteArchive
        FROM dbo.tbl_PrescriptionProductDetail;
    END

    IF OBJECT_ID(N'dbo.tblPrescriptionApprovalLogDeleteArchive', N'U') IS NULL
    BEGIN
        SELECT TOP (0) *
        INTO dbo.tblPrescriptionApprovalLogDeleteArchive
        FROM dbo.tblPrescriptionApprovalLog;
    END

    DECLARE @InsertColumnList NVARCHAR(MAX);
    DECLARE @SelectColumnList NVARCHAR(MAX);
    DECLARE @ArchiveQuery NVARCHAR(MAX);
    DECLARE @HasIdentity BIT;
    DECLARE @FromDateTime DATETIME;
    DECLARE @ToDateTime DATETIME;

    SET @FromDateTime = CONVERT(DATETIME, CONVERT(DATE, @FromDate));
    SET @ToDateTime = CONVERT(DATETIME, DATEADD(DAY, 1, CONVERT(DATE, @ToDate)));

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @InsertColumnList = STUFF((
            SELECT ',' + QUOTENAME(targetColumn.name)
            FROM sys.columns targetColumn
            INNER JOIN sys.columns sourceColumn
                ON sourceColumn.object_id = OBJECT_ID(N'dbo.tbl_PrescriptionProductDetail')
               AND sourceColumn.name = targetColumn.name
            WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tbl_PrescriptionProductDetailDeleteArchive')
            ORDER BY targetColumn.column_id
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

        SELECT @SelectColumnList = STUFF((
            SELECT ',tbl_PrescriptionProductDetail.' + QUOTENAME(targetColumn.name)
            FROM sys.columns targetColumn
            INNER JOIN sys.columns sourceColumn
                ON sourceColumn.object_id = OBJECT_ID(N'dbo.tbl_PrescriptionProductDetail')
               AND sourceColumn.name = targetColumn.name
            WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tbl_PrescriptionProductDetailDeleteArchive')
            ORDER BY targetColumn.column_id
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

        SET @HasIdentity = CASE
                               WHEN EXISTS
                               (
                                   SELECT 1
                                   FROM sys.identity_columns
                                   WHERE object_id = OBJECT_ID(N'dbo.tbl_PrescriptionProductDetailDeleteArchive')
                               )
                               THEN 1
                               ELSE 0
                           END;

        SET @ArchiveQuery = N'';

        IF @HasIdentity = 1
        BEGIN
            SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tbl_PrescriptionProductDetailDeleteArchive ON;';
        END

        SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tbl_PrescriptionProductDetailDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tbl_PrescriptionProductDetail
INNER JOIN dbo.tbl_PrescriptionMaster
    ON dbo.tbl_PrescriptionProductDetail.PrescriptionId = dbo.tbl_PrescriptionMaster.PrescriptionId
WHERE dbo.tbl_PrescriptionMaster.PrescriptionDate >= @FromDateTime
  AND dbo.tbl_PrescriptionMaster.PrescriptionDate < @ToDateTime;';

        IF @HasIdentity = 1
        BEGIN
            SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tbl_PrescriptionProductDetailDeleteArchive OFF;';
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
                ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblPrescriptionApprovalLog')
               AND sourceColumn.name = targetColumn.name
            WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblPrescriptionApprovalLogDeleteArchive')
            ORDER BY targetColumn.column_id
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

        SELECT @SelectColumnList = STUFF((
            SELECT ',tblPrescriptionApprovalLog.' + QUOTENAME(targetColumn.name)
            FROM sys.columns targetColumn
            INNER JOIN sys.columns sourceColumn
                ON sourceColumn.object_id = OBJECT_ID(N'dbo.tblPrescriptionApprovalLog')
               AND sourceColumn.name = targetColumn.name
            WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tblPrescriptionApprovalLogDeleteArchive')
            ORDER BY targetColumn.column_id
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

        SET @HasIdentity = CASE
                               WHEN EXISTS
                               (
                                   SELECT 1
                                   FROM sys.identity_columns
                                   WHERE object_id = OBJECT_ID(N'dbo.tblPrescriptionApprovalLogDeleteArchive')
                               )
                               THEN 1
                               ELSE 0
                           END;

        SET @ArchiveQuery = N'';

        IF @HasIdentity = 1
        BEGIN
            SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tblPrescriptionApprovalLogDeleteArchive ON;';
        END

        SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tblPrescriptionApprovalLogDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tblPrescriptionApprovalLog
INNER JOIN dbo.tbl_PrescriptionMaster
    ON dbo.tblPrescriptionApprovalLog.TableId = dbo.tbl_PrescriptionMaster.PrescriptionId
WHERE dbo.tbl_PrescriptionMaster.PrescriptionDate >= @FromDateTime
  AND dbo.tbl_PrescriptionMaster.PrescriptionDate < @ToDateTime;';

        IF @HasIdentity = 1
        BEGIN
            SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tblPrescriptionApprovalLogDeleteArchive OFF;';
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
                ON sourceColumn.object_id = OBJECT_ID(N'dbo.tbl_PrescriptionMaster')
               AND sourceColumn.name = targetColumn.name
            WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tbl_PrescriptionMasterDeleteArchive')
            ORDER BY targetColumn.column_id
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

        SELECT @SelectColumnList = STUFF((
            SELECT ',tbl_PrescriptionMaster.' + QUOTENAME(targetColumn.name)
            FROM sys.columns targetColumn
            INNER JOIN sys.columns sourceColumn
                ON sourceColumn.object_id = OBJECT_ID(N'dbo.tbl_PrescriptionMaster')
               AND sourceColumn.name = targetColumn.name
            WHERE targetColumn.object_id = OBJECT_ID(N'dbo.tbl_PrescriptionMasterDeleteArchive')
            ORDER BY targetColumn.column_id
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

        SET @HasIdentity = CASE
                               WHEN EXISTS
                               (
                                   SELECT 1
                                   FROM sys.identity_columns
                                   WHERE object_id = OBJECT_ID(N'dbo.tbl_PrescriptionMasterDeleteArchive')
                               )
                               THEN 1
                               ELSE 0
                           END;

        SET @ArchiveQuery = N'';

        IF @HasIdentity = 1
        BEGIN
            SET @ArchiveQuery = @ArchiveQuery + N'SET IDENTITY_INSERT dbo.tbl_PrescriptionMasterDeleteArchive ON;';
        END

        SET @ArchiveQuery = @ArchiveQuery + N'
INSERT INTO dbo.tbl_PrescriptionMasterDeleteArchive (' + @InsertColumnList + N')
SELECT ' + @SelectColumnList + N'
FROM dbo.tbl_PrescriptionMaster
WHERE dbo.tbl_PrescriptionMaster.PrescriptionDate >= @FromDateTime
  AND dbo.tbl_PrescriptionMaster.PrescriptionDate < @ToDateTime;';

        IF @HasIdentity = 1
        BEGIN
            SET @ArchiveQuery = @ArchiveQuery + N'
SET IDENTITY_INSERT dbo.tbl_PrescriptionMasterDeleteArchive OFF;';
        END

        EXEC sp_executesql
            @ArchiveQuery,
            N'@FromDateTime DATETIME, @ToDateTime DATETIME',
            @FromDateTime = @FromDateTime,
            @ToDateTime = @ToDateTime;

        DELETE SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionProductDetail
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionProductDetail
        INNER JOIN SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster
            ON SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionProductDetail.PrescriptionId = SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster.PrescriptionId
        WHERE SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster.PrescriptionDate >= @FromDateTime
          AND SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster.PrescriptionDate < @ToDateTime;

        DELETE SalesDisDB_SMC_NEWDB_Dynamic..tblPrescriptionApprovalLog
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tblPrescriptionApprovalLog
        INNER JOIN SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster
            ON SalesDisDB_SMC_NEWDB_Dynamic..tblPrescriptionApprovalLog.TableId = SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster.PrescriptionId
        WHERE SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster.PrescriptionDate >= @FromDateTime
          AND SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster.PrescriptionDate < @ToDateTime;

        DELETE FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_PrescriptionMaster
        WHERE PrescriptionDate >= @FromDateTime
          AND PrescriptionDate < @ToDateTime;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = CASE WHEN ERROR_SEVERITY() BETWEEN 0 AND 18 THEN ERROR_SEVERITY() ELSE 16 END,
            @ErrorState = CASE WHEN ERROR_STATE() BETWEEN 1 AND 255 THEN ERROR_STATE() ELSE 1 END;

        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        RAISERROR('%s', @ErrorSeverity, @ErrorState, @ErrorMessage);
    END CATCH
END
