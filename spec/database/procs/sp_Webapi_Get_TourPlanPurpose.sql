CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanPurpose]
	-- Add the parameters for the stored procedure here
@empId INT = NULL
AS
BEGIN
		
	SELECT TPId ,
           TPName , isnull(IsMarketVisit,0) IsMarketVisit , isnull(IsOtherVisit,0) IsOtherVisit
		   FROM dbo.tbl_TourPlanPurpose with (nolock) WHERE IsActive =1
		 

END
