
--------------------------------------------------
-- PROCEDURE: sp_Save_MonthlyAllowance
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Save_MonthlyAllowance
    @MonthlyAllowanceId INT = 0,
    @RoleName NVARCHAR(100),
    @AllowanceName NVARCHAR(200),
    @AllowanceAmount DECIMAL(18, 2),
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

    SET @AllowanceName = LTRIM(RTRIM(ISNULL(@AllowanceName, '')));

    IF @AllowanceName = ''
    BEGIN
        RAISERROR('AllowanceName is required.', 16, 1);
        RETURN;
    END;

    IF @AllowanceAmount < 0
    BEGIN
        RAISERROR('AllowanceAmount cannot be negative.', 16, 1);
        RETURN;
    END;

    IF @MonthlyAllowanceId > 0
    BEGIN
        IF EXISTS
        (
            SELECT 1
            FROM dbo.tblMonthlyAllowances WITH (NOLOCK)
            WHERE RoleName = @RoleName
              AND AllowanceName = @AllowanceName
              AND MonthlyAllowanceId <> @MonthlyAllowanceId
        )
        BEGIN
            RAISERROR('Monthly allowance already exists for this role and allowance name.', 16, 1);
            RETURN;
        END;

        UPDATE dbo.tblMonthlyAllowances
           SET RoleName = @RoleName,
               AllowanceName = @AllowanceName,
               AllowanceAmount = @AllowanceAmount,
               IsActive = @IsActive,
               UpdateBy = @SessionUserId,
               UpdateDate = GETDATE()
         WHERE MonthlyAllowanceId = @MonthlyAllowanceId;

        SELECT @MonthlyAllowanceId;
        RETURN;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.tblMonthlyAllowances WITH (NOLOCK)
        WHERE RoleName = @RoleName
          AND AllowanceName = @AllowanceName
    )
    BEGIN
        RAISERROR('Monthly allowance already exists for this role and allowance name.', 16, 1);
        RETURN;
    END;

    INSERT INTO dbo.tblMonthlyAllowances
    (
        RoleName,
        AllowanceName,
        AllowanceAmount,
        IsActive,
        EntryBy,
        EntryDate
    )
    VALUES
    (
        @RoleName,
        @AllowanceName,
        @AllowanceAmount,
        @IsActive,
        @SessionUserId,
        GETDATE()
    );

    SELECT SCOPE_IDENTITY();
END

