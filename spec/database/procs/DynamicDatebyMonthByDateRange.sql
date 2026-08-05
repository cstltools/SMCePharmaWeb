
CREATE PROCEDURE [dbo].[DynamicDatebyMonthByDateRange]
   
  @frmDate NVARCHAR(max),
  @toDate NVARCHAR(max)
AS
BEGIN
 
	

	   SELECT 
     STUFF(
                 (SELECT ',' +'['+ DateString+']' FROM (SELECT   distinct  format(DateString,'MMM-yyyy') DateString, MONTH(DateString) m , YEAR(DateString) y  FROM DateRange_To_TableSL(@frmDate,@toDate)   
               ) tbl  order by     m, y  asc  FOR XML PATH ('')), 1, 1, '' ) DateString
    END