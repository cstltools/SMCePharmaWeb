
--------------------------------------------------
-- PROCEDURE: sp_Save_SalesAssistantDAAmountClaimConfig
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Save_SalesAssistantDAAmountClaimConfig
    @SalesAssistantDAAmountClaimConfigId INT = 0,
    @RoleName NVARCHAR(100),
    @TourTypeId INT,
    @DAAmount DECIMAL(18, 2),
    @IsActive BIT,
    @SessionUserId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF ISNULL(@RoleName, '') = ''
    BEGIN
        RAISERROR('RoleName is required.', 16, 1);
        RETURN;
    END;

    IF ISNULL(@TourTypeId, 0) <= 0
    BEGIN
        RAISERROR('TourTypeId is required.', 16, 1);
        RETURN;
    END;

    IF @DAAmount < 0
    BEGIN
        RAISERROR('DAAmount cannot be negative.', 16, 1);
        RETURN;
    END;

    IF @SalesAssistantDAAmountClaimConfigId > 0
    BEGIN
        IF EXISTS
        (
            SELECT 1
            FROM dbo.tblSalesAssistantDAAmountClaimConfig WITH (NOLOCK)
            WHERE RoleName = @RoleName
              AND TourTypeId = @TourTypeId
              AND SalesAssistantDAAmountClaimConfigId <> @SalesAssistantDAAmountClaimConfigId
        )
        BEGIN
            RAISERROR('Configuration already exists for this role and station type.', 16, 1);
            RETURN;
        END;

        UPDATE dbo.tblSalesAssistantDAAmountClaimConfig
           SET RoleName = @RoleName,
               TourTypeId = @TourTypeId,
               DAAmount = @DAAmount,
               IsActive = @IsActive,
               UpdateBy = @SessionUserId,
               UpdateDate = GETDATE()
         WHERE SalesAssistantDAAmountClaimConfigId = @SalesAssistantDAAmountClaimConfigId;

        SELECT @SalesAssistantDAAmountClaimConfigId;
        RETURN;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.tblSalesAssistantDAAmountClaimConfig WITH (NOLOCK)
        WHERE RoleName = @RoleName
          AND TourTypeId = @TourTypeId
    )
    BEGIN
        RAISERROR('Configuration already exists for this role and station type.', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.tblSalesAssistantDAAmountClaimConfig
    (
        RoleName,
        TourTypeId,
        DAAmount,
        IsActive,
        EntryBy,
        EntryDate
    )
    VALUES
    (
        @RoleName,
        @TourTypeId,
        @DAAmount,
        @IsActive,
        @SessionUserId,
        GETDATE()
    );

    SELECT SCOPE_IDENTITY();
END

