-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctoreVisitTypeForDcr]
	-- Add the parameters for the stored procedure here

AS
BEGIN

	SELECT DocVisitTypeId AS TourTypeId ,
         VisitTypeName AS  TourTypeName  FROM tbl_DoctorVisitType WHERE IsActive =1


	--SELECT TourTypeId ,
 --          TourTypeName  FROM dbo.tbl_TourPlanType WHERE IsActive =1
END

