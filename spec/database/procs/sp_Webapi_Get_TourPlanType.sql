CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanType]
	-- Add the parameters for the stored procedure here
@empId INT = NULL
AS
BEGIN
		
		SELECT TourTypeId ,
               TourTypeName 
			    FROM dbo.tbl_TourPlanType WHERE IsActive = 1
		 

END
