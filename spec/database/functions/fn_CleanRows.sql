CREATE FUNCTION dbo.fn_CleanRows
(
    @RowName NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Clean NVARCHAR(100);

    -- NULL check
    IF @RowName IS NULL
        RETURN NULL;

    -- Replace newline, carriage return, tab, then trim spaces
    SET @Clean = LTRIM(RTRIM(
                    REPLACE(
                        REPLACE(
                            REPLACE(@RowName, CHAR(13), ''), -- CR
                        CHAR(10), ''),                      -- LF
                    CHAR(9), '')                            -- Tab
                ));

    RETURN @Clean;
END;
