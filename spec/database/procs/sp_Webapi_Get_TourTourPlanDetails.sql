-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourTourPlanDetails]
	-- Add the parameters for the stored procedure here
@month INT = NULL,
@year INT = NULL,
@empId INT = NULL
AS
BEGIN
		
		SELECT  B.DocTPDetailsId,
		DoctorName_DV AS DoctorName,
		B.DocTPDetailsId,
				   MONTH(B.TourPlanDate) AS MonthValue,
		   YEAR(B.TourPlanDate) AS YearValue,
		   DAY(b.TourPlanDate) AS DayValue,
		   	Convert(varchar(10), b.TourPlanDate,120) AS TourPlanDate,
			A.IsFinalSubmit
		
		 FROM dbo.tbl_DoctorTourPlanMaster A 
		INNER JOIN dbo.tbl_DoctorTourPlanDetail B ON B.DocTPMaster = A.DocTPMaster
		 
		WHERE A.EmpInfoId = @empId AND MONTH(B.TourPlanDate) = @month AND YEAR(B.TourPlanDate) = @year

END

