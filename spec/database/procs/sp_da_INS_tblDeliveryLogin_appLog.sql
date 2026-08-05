
CREATE   PROCEDURE dbo.sp_da_INS_tblDeliveryLogin_appLog
    @UserId INT,
    @Latitude DECIMAL(18, 8),
    @Longitude DECIMAL(18, 8),
    @Address NVARCHAR(500) = NULL,
    @EntryDate DATETIME2(0) = NULL,
    @ServerDate DATETIME2(0) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ResolvedServerDate DATETIME2(0) = ISNULL(@ServerDate, GETDATE());
    DECLARE @ResolvedEntryDate DATETIME2(0) = ISNULL(@EntryDate, @ResolvedServerDate);

    INSERT INTO dbo.tblDeliveryLogin_appLog
    (
        UserId,
        Latitude,
        Longitude,
        [Address],
        EntryDate,
        ServerDate
    )
    VALUES
    (
        @UserId,
        ISNULL(@Latitude, 0),
        ISNULL(@Longitude, 0),
        NULLIF(@Address, N''),
        @ResolvedEntryDate,
        @ResolvedServerDate
    );

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END
