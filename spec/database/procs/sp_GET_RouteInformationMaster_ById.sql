

 CREATE PROCEDURE [dbo].[sp_GET_RouteInformationMaster_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select    STUFF( (SELECT CONCAT(',', brn.WeekNameId , '') FROM dbo.tblRouteInformationWeekNameDetails brn(NOLOCK)  WHERE brn.RouteInformationMasterId=tblRouteInformationMaster.RouteInformationMasterId ORDER BY brn.RouteInformationMasterId FOR XML PATH ('') ),1,1,'') AS BrandId,* from tblRouteInformationMaster where RouteInformationMasterId = @id
      
    END


