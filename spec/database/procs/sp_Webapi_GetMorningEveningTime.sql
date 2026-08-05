create PROCEDURE [dbo].[sp_Webapi_GetMorningEveningTime] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	@ShiftInfo nvarchar(50) 
AS
BEGIN  
SELECT 
   S_StartTime AS StartTime ,
    S_EndTime AS EndTime 
FROM tblTourPlanShiftInfo
WHERE ShiftInfo = @ShiftInfo;

 
 END
  