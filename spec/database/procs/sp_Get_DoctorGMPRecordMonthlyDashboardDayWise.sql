

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_DoctorGMPRecordMonthlyDashboardDayWise]
	-- Add the parameters for the stored procedure here
@param nvarchar(max),
	@FrmDate nvarchar(max),
	@ToDate nvarchar(max)

AS
BEGIN
   

    DECLARE @Q NVARCHAR(MAX)
	SET @Q='SELECT DcrDate, Criteria Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT   DISTINCT Convert(Date,DcrDate) DcrDate, format( Convert(Date,DcrDate),''dd-MMM'') Criteria,tbl_DCRInfo.DoctorId FROM dbo.tbl_DCRInfo  with (nolock)
 
LEFT JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_DCRInfo.DoctorId


WHERE    tbl_DCRInfo.DcrId is not null '  +@param+'   ) AS tblt
  GROUP BY Convert(Date,DcrDate), Criteria

     order by  DcrDate asc

   
   
   
    '

EXEC sys.sp_executesql @Q


END
