CREATE PROCEDURE [dbo].[sp_GET_DZSMwiseReportParam_new] 

    @FromDate nvarchar(Max),
	@ToDate nvarchar(Max),
	@parm  nvarchar(Max)
		
AS
BEGIN
DECLARE @SqlStatement NVARCHAR(MAX)

DECLARE @Month int 
DECLARE @year int 



 set @Month=  MONTH(CONVERT(date, @FromDate))

 set @year= Year(CONVERT(date, @FromDate))

  

SET @SqlStatement = N'Select  * from  tblDZSMwiseReportParam with (nolock)

 where  RegionId is not null  and MonthValue='''+CAST(@Month as nvarchar(max))+''' and YearValue='''++CAST(@year as nvarchar(max))+'''' +@parm 
  EXEC(@SqlStatement)
END

