
create FUNCTION [dbo].[MonthValueToName] (@MonthValue INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @MonthName NVARCHAR(50)

    SELECT @MonthName = 
        CASE @MonthValue
            WHEN 1 THEN 'January'
            WHEN 2 THEN 'February'
            WHEN 3 THEN 'March'
            WHEN 4 THEN 'April'
            WHEN 5 THEN 'May'
            WHEN 6 THEN 'June'
            WHEN 7 THEN 'July'
            WHEN 8 THEN 'August'
            WHEN 9 THEN 'September'
            WHEN 10 THEN 'October'
            WHEN 11 THEN 'November'
            WHEN 12 THEN 'December'
            ELSE 'Invalid Month'
        END

    RETURN @MonthName
END
