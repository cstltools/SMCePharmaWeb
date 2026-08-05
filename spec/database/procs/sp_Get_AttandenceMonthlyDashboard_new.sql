

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_AttandenceMonthlyDashboard_new]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max)
	,
	@param nvarchar(max)

AS
BEGIN
   
   
    DECLARE @Q NVARCHAR(MAX)='
  SELECT AttendanceDate,  CAST(DayValue as nvarchar(max)) Criteria, isnull(COUNT(tblt.EmpInfoId),0) AS Amount FROM (
   SELECT  distinct CONVERT(Date, mas.AttendanceDate) AttendanceDate, format(mas.AttendanceDate,''dd-MMM'') DayValue,mas.EmpInfoId FROM dbo.tblMarketAttendance_Master_webapi mas
  
WHERE  mas.AttendanceDate is not null   '+@param+'   ) AS tblt
  GROUP BY DayValue  ,AttendanceDate

   having isnull(COUNT(tblt.EmpInfoId),0)>0
 
   ORDER BY AttendanceDate asc

   '
   				
EXEC sp_executesql @Q

END


 

