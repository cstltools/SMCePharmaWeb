-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DWSPDetails]
	-- Add the parameters for the stored procedure here
@month INT = NULL,
@year INT = NULL,
@empId INT = NULL
AS
BEGIN
		
		SELECT  A.DWSPMasterId,
		B.FCBAmount,
				B.GeneralAmount,
				B.CampaignAmount,
		B.DWSPDetailId,
				   MONTH(B.DWSPDate) AS MonthValue,
		   YEAR(B.DWSPDate) AS YearValue,
		   DAY(b.DWSPDate) AS DayValue,
		   	Convert(varchar(10), b.DWSPDate,120) AS DWSPDate,
			A.IsFinalSubmit
		
		 FROM dbo.tbl_DWSPMaster A 
		INNER JOIN dbo.tbl_DWSPDetail B ON B.DWSPMasterId = A.DWSPMasterId
	 
		WHERE A.EmpInfoId = @empId AND MONTH(B.DWSPDate) = @month AND YEAR(B.DWSPDate) = @year

END

