

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_DoctorGMPxRecordMonthlyDashboardDayWise]
	-- Add the parameters for the stored procedure here

@param nvarchar(max),
	@FrmDate nvarchar(max),
	@ToDate nvarchar(max)

AS
BEGIN
   

   
    DECLARE @Q NVARCHAR(MAX)
	SET @Q='SELECT PrescriptionDate, Criteria Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT DISTINCT Convert(Date,PrescriptionDate) PrescriptionDate, format( Convert(Date,PrescriptionDate),''dd-MMM'') Criteria,tbl_PrescriptionMaster.DoctorId FROM dbo.tbl_PrescriptionMaster   with (nolock) 
 
LEFT JOIN dbo.tblDoctorMaster   with (nolock)  ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_PrescriptionMaster.DoctorId

WHERE tbl_PrescriptionMaster.PrescriptionId is not null '   +@param+'    ) AS tblt
  GROUP BY PrescriptionDate, Criteria

   order by  PrescriptionDate asc

   
   

     '

EXEC sys.sp_executesql @Q



END

