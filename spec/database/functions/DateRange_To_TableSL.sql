CREATE FUNCTION [dbo].[DateRange_To_TableSL] ( @minDate_Str NVARCHAR(30), @maxDate_Str NVARCHAR(30))

RETURNS  @Result TABLE(SL int, DateString date)

AS

begin

      INSERT INTO @Result(SL,DateString )
   SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS SL, CONVERT(date,DateString) FROM dbo.DateRange_To_Table (@minDate_Str,@maxDate_Str)



    return

end   