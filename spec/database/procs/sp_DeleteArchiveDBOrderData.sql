
create PROCEDURE [dbo].[sp_DeleteArchiveDBOrderData]
    @DatabaseName NVARCHAR(128),
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_NULLS ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;

    IF @FromDate IS NULL
        SET @FromDate = '19000101';
    IF @ToDate IS NULL
        SET @ToDate = '99991231';

    SET @DatabaseName = LTRIM(RTRIM(@DatabaseName));

    IF ISNULL(@DatabaseName, '') = ''
    BEGIN
        RAISERROR('DatabaseName is required.', 16, 1);
        RETURN;
    END;

    IF DB_ID(@DatabaseName) IS NULL
    BEGIN
        RAISERROR('Selected database was not found.', 16, 1);
        RETURN;
    END;

    IF @FromDate > @ToDate
    BEGIN
        RAISERROR('FromDate cannot be greater than ToDate.', 16, 1);
        RETURN;
    END;

    DECLARE @Sql NVARCHAR(MAX);
    DECLARE @DbName NVARCHAR(258);

    SET @DbName = QUOTENAME(@DatabaseName);

    BEGIN TRAN;
    BEGIN TRY
        SET @Sql = N'
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;

DELETE od
FROM ' + @DbName + N'.dbo.tblOrderDetail od
INNER JOIN ' + @DbName + N'.dbo.tblOrder o
    ON od.OrderId = o.OrderId
WHERE o.SubmissionDate >= @FromDate
  AND o.SubmissionDate < DATEADD(DAY, 1, @ToDate);

DELETE o
FROM ' + @DbName + N'.dbo.tblOrder o
WHERE o.SubmissionDate >= @FromDate
  AND o.SubmissionDate < DATEADD(DAY, 1, @ToDate);';

        EXEC sp_executesql
            @Sql,
            N'@FromDate DATE, @ToDate DATE',
            @FromDate = @FromDate,
            @ToDate = @ToDate;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
