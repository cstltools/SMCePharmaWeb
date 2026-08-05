

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create

 PROCEDURE [dbo].[sp_Get_DoctorGMPRecordMonthlyDashboardZoneWise]
	-- Add the parameters for the stored procedure here
@param nvarchar(max),
	@FrmDate nvarchar(max),
	@ToDate nvarchar(max)

AS
BEGIN
   

    DECLARE @Q NVARCHAR(MAX)
	SET @Q='SELECT   Criteria Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT     rg.RegionCode Criteria,tbl_DCRInfo.DoctorId FROM dbo.tbl_DCRInfo  with (nolock)
 
LEFT JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_DCRInfo.DoctorId
LEFT JOIN dbo.tblRegion rg   with (nolock)  ON rg.RegionId=dbo.tbl_DCRInfo.RegionId


WHERE    tbl_DCRInfo.DcrId is not null  '  +@param+'   ) AS tblt
  GROUP BY  Criteria

     order by  Criteria asc

   
   
   
    '

EXEC sys.sp_executesql @Q


END
