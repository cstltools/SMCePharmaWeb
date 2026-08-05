create PROCEDURE [dbo].[sp_Get_ALl_Thana_List]
	-- Add the parameters for the stored procedure here

AS
BEGIN


Select t.ThanaId,divi.DivisionName,Dis.DistrictName,t.ThanaName from tbl_Thana t
left join tbl_District Dis on Dis.DistrictId = t.district_id
left join tbl_Division divi on divi.DivisionId = Dis.DivisionId
where t.IsActive = 1



END