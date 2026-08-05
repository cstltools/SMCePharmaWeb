 CREATE PROCEDURE [dbo].[sp_GET_ThanaInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

Select t.ThanaId,divi.DivisionId,Dis.DistrictId,t.ThanaName from tbl_Thana t
left join tbl_District Dis on Dis.DistrictId = t.district_id
left join tbl_Division divi on divi.DivisionId = Dis.DivisionId
where    ThanaId = @id
	   
    END


