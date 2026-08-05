

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create

 PROCEDURE [dbo].[sp_Get_DoctorGMPxRecordMonthlyDashboard_new]
	-- Add the parameters for the stored procedure here

@param nvarchar(max),
	@FrmDate nvarchar(max),
	@ToDate nvarchar(max)

AS
BEGIN
   

   
    DECLARE @Q NVARCHAR(MAX)
	SET @Q='SELECT DoctorTypeName Criteria,COUNT(tblt.DoctorId)AS Amount FROM (
   SELECT DISTINCT DoctorTypeName,tbl_PrescriptionMaster.DoctorId FROM dbo.tbl_PrescriptionMaster   with (nolock) 
 
LEFT JOIN dbo.tblDoctorMaster   with (nolock)  ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_PrescriptionMaster.DoctorId
LEFT JOIN dbo.tblDoctorType   with (nolock)  ON dbo.tblDoctorType.DoctorTypeId=dbo.tblDoctorMaster.DoctorTypeId

WHERE Convert(Date,PrescriptionDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+'    ) AS tblt
   GROUP BY DoctorTypeName

   
   

     '

EXEC sys.sp_executesql @Q



END

