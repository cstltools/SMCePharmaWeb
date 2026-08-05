CREATE PROCEDURE [dbo].[sp_ValidateTimeOutOfRange]
    @MainTime NVARCHAR(20),    -- AM/PM formatted time
    @ShiftInfo NVARCHAR(50),   -- Shift information (e.g., "Morning", "Evening")
    @IsValid BIT OUTPUT,       -- Output: Is time valid (within range)
    @Message NVARCHAR(255) OUTPUT  -- Output: Message describing the result
AS
BEGIN
    -- Declare variables for StartTime and EndTime
    DECLARE @StartTime TIME(7);
    DECLARE @EndTime TIME(7);
    DECLARE @ConvertedMainTime TIME(7);

    -- Convert MainTime to TIME(7) in 24-hour format
    SET @ConvertedMainTime = CONVERT(TIME(7), @MainTime, 109); -- Style 109 for AM/PM

    -- Retrieve StartTime and EndTime from tblTourPlanShiftInfo based on ShiftInfo
    SELECT @StartTime = StartTime, @EndTime = EndTime
    FROM tblTourPlanShiftInfo
    WHERE ShiftInfo = @ShiftInfo;

    -- Validate if ConvertedMainTime is within StartTime and EndTime
    IF @ConvertedMainTime >= @StartTime AND @ConvertedMainTime <= @EndTime
    BEGIN
        SET @IsValid = 1;
        SET @Message = 'Time is within the range.';
    END
    ELSE
    BEGIN
        SET @IsValid = 0;
        SET @Message = 'Time is outside the range.';
    END

    -- This SELECT will return a result set to be captured by the DataTable
    SELECT @IsValid AS IsValid, @Message AS Message;
END
