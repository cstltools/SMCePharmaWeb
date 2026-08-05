

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_AttandenceMonthlyDashboard]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max)
	,
	@param nvarchar(max)

AS
BEGIN
   

   SELECT 'Day- '+ CAST(DayValue as nvarchar(max)) Criteria,COUNT(tblt.EmpInfoId)AS Amount FROM (
   SELECT DISTINCT DAY(mas.AttendanceDate) DayValue,mas.EmpInfoId FROM dbo.tblMarketAttendance_Master_webapi mas
  
WHERE MONTH(AttendanceDate)=MONTH(@Month) AND YEAR(AttendanceDate)=YEAR(@Year)  ) AS tblt
   GROUP BY DayValue


--   union all  
--   SELECT   'Total' Criteria,COUNT(mas.EmpInfoId) Amount FROM dbo.tblMarketAttendance_Master_webapi mas
  
--WHERE MONTH(AttendanceDate)=MONTH(@Month) AND YEAR(AttendanceDate)=YEAR(@Year)  
   

   
   




END

