

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create

 PROCEDURE [dbo].[sp_Get_DoctorGMPRecordMonthlyDashboard_New]
	-- Add the parameters for the stored procedure here
@param nvarchar(max),
	@FrmDate nvarchar(max),
	@ToDate nvarchar(max)

AS
BEGIN
   

    DECLARE @Q NVARCHAR(MAX)
	SET @Q='SELECT DoctorTypeName Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT DISTINCT DoctorTypeName,tbl_DCRInfo.DoctorId FROM dbo.tbl_DCRInfo  with (nolock)
 
LEFT JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_DCRInfo.DoctorId
LEFT JOIN dbo.tblDoctorType  with (nolock) ON dbo.tblDoctorType.DoctorTypeId=dbo.tblDoctorMaster.DoctorTypeId

WHERE  Convert(Date,DcrDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+'   ) AS tblt
   GROUP BY DoctorTypeName

   
   
   
    '

EXEC sys.sp_executesql @Q


END
