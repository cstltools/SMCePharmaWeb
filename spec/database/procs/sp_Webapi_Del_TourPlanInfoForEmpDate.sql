CREATE PROCEDURE [dbo].[sp_Webapi_Del_TourPlanInfoForEmpDate]
	 
    @empId INT = null ,
	 @TourDate datetime = NULL

AS
    BEGIN

	--DECLARE @tpMasterId int

	--SELECT @tpMasterId=TPMaster FROM dbo.tbl_TourPlanMaster WHERE MonthValue = MONTH(@TourDate) AND YearValue = YEAR(@TourDate) AND EmpInfoId = @empId

	declare @tourpla nvarchar(max)=0

	select @tourpla=TourPlanId from dbo.tbl_TourPlanInfo   WHERE CONVERT(DATE,TourPlanDate) = CONVERT(DATE,@TourDate)   AND EmpInfoId = @empId

	DELETE FROM dbo.tbl_TourPlanInfo   WHERE CONVERT(DATE,TourPlanDate) = CONVERT(DATE,@TourDate)   AND EmpInfoId = @empId

	DELETE FROM dbo.tblTPCustomerDetail 
	  WHERE TourPlanId in (select * from fnSplit(@tourpla,','))

	 END
