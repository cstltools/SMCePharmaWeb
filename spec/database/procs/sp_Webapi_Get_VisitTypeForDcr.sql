-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_VisitTypeForDcr]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	SELECT TourTypeId ,
           TourTypeName  FROM dbo.tbl_TourPlanType WHERE IsActive =1
END

