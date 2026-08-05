create PROCEDURE [dbo].[sp_Webapi_Get_TourPlanPurposeForOtherVisit]
	-- Add the parameters for the stored procedure here
@empId INT = NULL
AS
BEGIN
		
	SELECT TPId ,
           TPName 
		   FROM dbo.tbl_TourPlanPurpose with (nolock) WHERE IsActive =1 and IsOtherVisit=1
		 

END