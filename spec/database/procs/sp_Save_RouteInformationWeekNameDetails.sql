-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_RouteInformationWeekNameDetails]
	-- Add the parameters for the stored procedure here
@RouteInformationMasterId INT = NULL,
@WeekNameId int = NULL
AS
BEGIN

 


		
INSERT INTO [dbo].[tblRouteInformationWeekNameDetails]
           ([RouteInformationMasterId]
           ,[WeekNameId])
     VALUES
           (@RouteInformationMasterId 
           ,@WeekNameId)

END

