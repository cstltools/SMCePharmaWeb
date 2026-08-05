
CREATE PROCEDURE [dbo].[DynamicDatebyMonthYear]
   
  @Month NVARCHAR(255),
  @Year NVARCHAR(255)
AS
BEGIN
 declare @Date datetime
 set @Date=CONVERT(Date,'01-'+@Month+'-'+@Year)
 

 

 select '['+ CONVERT(nvarchar(max),CONVERT(date,DATEADD(dd,a.n-1,datefromparts(@Year,@Month,1))))+']' mainDate  
from    (
         select top  (DAY(EOMONTH(@Date))) ROW_NUMBER() over (order by a.object_id) as n
         from   sys.all_objects a
      ) a
	  
	  
	   where   DATEPART(mm,DATEADD(dd,a.n-1,datefromparts(@Year,@Month,1)))=@Month



	   END