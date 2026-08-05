-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].sp_Webapi_Get_BSPDistrict
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	SELECT DistrictId,DistrictName, DivisionId FROM dbo.tblBSPDistrict WHERE IsActive = 1

END

