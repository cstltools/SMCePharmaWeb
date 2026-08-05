CREATE PROCEDURE [dbo].[sp_Get_ALl_District_List]
	-- Add the parameters for the stored procedure here

AS
BEGIN


Select divi.DivisionName,DistrictName, DistrictId from tbl_District
left join tbl_Division divi on divi.DivisionId = tbl_District.DivisionId


END