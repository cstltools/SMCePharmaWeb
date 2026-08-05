CREATE   PROCEDURE [dbo].[sp_WebApi_SaveProviderDropoutIntrigration]
    @programName NVARCHAR(50) = NULL,
    @providerCode NVARCHAR(50) = NULL,
    @providerName NVARCHAR(200) = NULL,
    @mobileNo NVARCHAR(30) = NULL,
    @nid NVARCHAR(30) = NULL,
    @email NVARCHAR(255) = NULL,
    @outlet NVARCHAR(200) = NULL,
    @dropoutReason NVARCHAR(500) = NULL,
    @insertedAt DATETIME2(7) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @providerIDropoutIntrigrationd BIGINT;

        INSERT INTO [dbo].[tblProviderDropoutIntrigration]
        (
            [programName],
            [providerCode],
            [providerName],
            [mobileNo],
            [nid],
            [email],
            [outlet],
            [dropoutReason],
            [insertedAt]
        )
        VALUES
        (
            @programName,
            @providerCode,
            @providerName,
            @mobileNo,
            @nid,
            @email,
            @outlet,
            @dropoutReason,
            ISNULL(@insertedAt, SYSDATETIME())
        );

        SET @providerIDropoutIntrigrationd = CAST(SCOPE_IDENTITY() AS BIGINT);

        SELECT
            CAST(1 AS BIT) AS IsSuccess,
            N'inserted' AS [Action],
            N'Provider dropout info saved successfully.' AS [Message],
            CAST(NULL AS NVARCHAR(4000)) AS ErrorMessage,
            @providerIDropoutIntrigrationd AS providerIDropoutIntrigrationd;
    END TRY
    BEGIN CATCH
        SELECT
            CAST(0 AS BIT) AS IsSuccess,
            CAST(NULL AS NVARCHAR(20)) AS [Action],
            N'Provider dropout info save failed.' AS [Message],
            ERROR_MESSAGE() AS ErrorMessage,
            CAST(NULL AS BIGINT) AS providerIDropoutIntrigrationd;
    END CATCH
END
