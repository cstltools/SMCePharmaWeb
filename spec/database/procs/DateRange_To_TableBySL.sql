create PROCEDURE  [DateRange_To_TableBySL]  

  @minDate_Str NVARCHAR(30),
   @maxDate_Str NVARCHAR(30)

AS
 begin

   SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@minDate_Str,@maxDate_Str)


   end
 