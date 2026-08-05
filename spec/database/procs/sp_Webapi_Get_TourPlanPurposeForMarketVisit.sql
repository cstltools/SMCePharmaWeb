create PROCEDURE [dbo].[sp_Webapi_Get_TourPlanPurposeForMarketVisit]
	-- Add the parameters for the stored procedure here
@empId INT = NULL
AS
BEGIN
		
	SELECT TPId ,
           TPName 
		   FROM dbo.tbl_TourPlanPurpose with (nolock) WHERE IsActive =1 and IsMarketVisit=1
		 

END
