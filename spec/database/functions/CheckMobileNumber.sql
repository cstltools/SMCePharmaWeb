CREATE FUNCTION CheckMobileNumber
(
    @MobileNumber VARCHAR(15) -- Assuming mobile numbers are stored as strings
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT

    -- Remove any non-numeric characters from the mobile number
    SET @MobileNumber = REPLACE(@MobileNumber, '-', '')

    -- Extract the prefix from the mobile number
    DECLARE @MobilePrefix VARCHAR(3)
    SET @MobilePrefix = LEFT(@MobileNumber, 3)

    -- Check if the mobile number starts with one of the specified prefixes
    IF @MobilePrefix IN ('013', '015', '017', '016', '018', '019', '014')
        SET @Result = 1
    ELSE
        SET @Result = 0

    RETURN @Result
END
