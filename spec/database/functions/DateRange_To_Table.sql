CREATE FUNCTION [dbo].[DateRange_To_Table] ( @minDate_Str NVARCHAR(30), @maxDate_Str NVARCHAR(30))

RETURNS  @Result TABLE(DateString date)

AS

begin

    DECLARE @minDate DATETIME, @maxDate DATETIME
    SET @minDate = CONVERT(Datetime, @minDate_Str,103)
    SET @maxDate = CONVERT(Datetime, @maxDate_Str,103)


    INSERT INTO @Result(DateString )
    SELECT   CONVERT(Date, @minDate) 



    WHILE @maxDate > @minDate
    BEGIN
        SET @minDate = (SELECT DATEADD(dd,1,@minDate))
        INSERT INTO @Result(DateString )
        SELECT    CONVERT(Date,@minDate)
    END




    return

end   