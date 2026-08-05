CREATE   PROCEDURE [dbo].[sp_WebApi_SaveEPharmaPersonInfo]
    @BSPCode NVARCHAR(MAX),
    @Name NVARCHAR(MAX),
    @OwnerName NVARCHAR(MAX) = NULL,
    @Address NVARCHAR(MAX) = NULL,
    @Mobile NVARCHAR(MAX) = NULL,
    @Division NVARCHAR(MAX) = NULL,
    @District NVARCHAR(MAX) = NULL,
    @Upazila NVARCHAR(MAX) = NULL,
    @ProviderType NVARCHAR(50) = NULL,
    @UpsertMode SQL_VARIANT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @HasUpsertMode BIT = CASE WHEN COL_LENGTH('dbo.tblPersonInfo', 'upsertMode') IS NULL THEN 0 ELSE 1 END;
        DECLARE @EntryDateColumn NVARCHAR(258);
        DECLARE @UpdateDateColumn NVARCHAR(258);
        DECLARE @HasEntryDate BIT;
        DECLARE @HasUpdateDate BIT;
        DECLARE @Action NVARCHAR(20);
        DECLARE @Sql NVARCHAR(MAX);
        DECLARE @ParameterDefinition NVARCHAR(MAX) =
            N'@BSPCode NVARCHAR(MAX),
              @Name NVARCHAR(MAX),
              @OwnerName NVARCHAR(MAX),
              @Address NVARCHAR(MAX),
              @Mobile NVARCHAR(MAX),
              @Division NVARCHAR(MAX),
              @District NVARCHAR(MAX),
              @Upazila NVARCHAR(MAX),
              @ProviderType NVARCHAR(50),
              @UpsertMode SQL_VARIANT';
        DECLARE @UpsertModeType NVARCHAR(128);
        DECLARE @UpsertModeExpression NVARCHAR(300);

        SELECT @EntryDateColumn = QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'tblPersonInfo'
          AND LOWER(COLUMN_NAME) = 'entrydate';

        SELECT @UpdateDateColumn = QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'tblPersonInfo'
          AND LOWER(COLUMN_NAME) = 'updatedate';

        SET @HasEntryDate = CASE WHEN @EntryDateColumn IS NULL THEN 0 ELSE 1 END;
        SET @HasUpdateDate = CASE WHEN @UpdateDateColumn IS NULL THEN 0 ELSE 1 END;

        IF @HasUpsertMode = 1
        BEGIN
            SELECT
                @UpsertModeType =
                    CASE
                        WHEN DATA_TYPE IN ('varchar', 'char', 'nvarchar', 'nchar', 'binary', 'varbinary')
                             AND CHARACTER_MAXIMUM_LENGTH = -1
                            THEN DATA_TYPE + '(MAX)'
                        WHEN DATA_TYPE IN ('varchar', 'char', 'nvarchar', 'nchar', 'binary', 'varbinary')
                            THEN DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
                        WHEN DATA_TYPE IN ('decimal', 'numeric')
                            THEN DATA_TYPE + '(' + CAST(NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(NUMERIC_SCALE AS VARCHAR(10)) + ')'
                        WHEN DATA_TYPE IN ('datetime2', 'datetimeoffset', 'time')
                            THEN DATA_TYPE + '(' + CAST(DATETIME_PRECISION AS VARCHAR(10)) + ')'
                        ELSE DATA_TYPE
                    END
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = 'dbo'
              AND TABLE_NAME = 'tblPersonInfo'
              AND COLUMN_NAME = 'upsertMode';

            SET @UpsertModeExpression =
                CASE
                    WHEN @UpsertMode IS NULL THEN N'NULL'
                    ELSE N'CAST(@UpsertMode AS ' + @UpsertModeType + N')'
                END;
        END

        IF EXISTS (SELECT 1 FROM dbo.tblPersonInfo WHERE [BSPCode] = @BSPCode)
        BEGIN
            SET @Action = N'updated';

            SET @Sql =
                N'UPDATE dbo.tblPersonInfo
                  SET [Name] = @Name,
                      [OwnerName] = @OwnerName,
                      [Address] = @Address,
                      [Mobile] = @Mobile,
                      [Division] = @Division,
                      [District] = @District,
                      [Upazila] = @Upazila' +
                CASE
                    WHEN @HasUpdateDate = 1 THEN N', ' + @UpdateDateColumn + N' = GETDATE()'
                    ELSE N''
                END +
                N',
                      [ProviderType] = @ProviderType' +
                CASE
                    WHEN @HasUpsertMode = 1 THEN N', [upsertMode] = ' + @UpsertModeExpression
                    ELSE N''
                END +
                N' WHERE [BSPCode] = @BSPCode;';
        END
        ELSE
        BEGIN
            SET @Action = N'inserted';

            SET @Sql =
                N'INSERT INTO dbo.tblPersonInfo
                  (
                      [BSPCode],
                      [Name],
                      [OwnerName],
                      [Address],
                      [Mobile],
                      [Division],
                      [District],
                      [Upazila]' +
                CASE
                    WHEN @HasEntryDate = 1 THEN N', ' + @EntryDateColumn
                    ELSE N''
                END +
                CASE
                    WHEN @HasUpdateDate = 1 THEN N', ' + @UpdateDateColumn
                    ELSE N''
                END +
                N',
                      [ProviderType]' +
                CASE
                    WHEN @HasUpsertMode = 1 THEN N', [upsertMode]'
                    ELSE N''
                END +
                N')
                  VALUES
                  (
                      @BSPCode,
                      @Name,
                      @OwnerName,
                      @Address,
                      @Mobile,
                      @Division,
                      @District,
                      @Upazila' +
                CASE
                    WHEN @HasEntryDate = 1 THEN N', GETDATE()'
                    ELSE N''
                END +
                CASE
                    WHEN @HasUpdateDate = 1 THEN N', GETDATE()'
                    ELSE N''
                END +
                N',
                      @ProviderType' +
                CASE
                    WHEN @HasUpsertMode = 1 THEN N', ' + @UpsertModeExpression
                    ELSE N''
                END +
                N');';
        END

        EXEC sys.sp_executesql
            @Sql,
            @ParameterDefinition,
            @BSPCode = @BSPCode,
            @Name = @Name,
            @OwnerName = @OwnerName,
            @Address = @Address,
            @Mobile = @Mobile,
            @Division = @Division,
            @District = @District,
            @Upazila = @Upazila,
            @ProviderType = @ProviderType,
            @UpsertMode = @UpsertMode;

        SELECT
            CAST(1 AS BIT) AS IsSuccess,
            @Action AS [Action],
            N'Person info ' + @Action + N' successfully.' AS [Message],
            CAST(NULL AS NVARCHAR(4000)) AS ErrorMessage;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(0 AS BIT) AS IsSuccess,
            CAST(NULL AS NVARCHAR(20)) AS [Action],
            N'Person info save failed.' AS [Message],
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
