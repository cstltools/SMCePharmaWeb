 CREATE PROCEDURE [dbo].[sp_GET_DistrictInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

Select  divi.DivisionId,t.DistrictId,t.DistrictName  from tbl_District t
 
left join tbl_Division divi on divi.DivisionId = t.DivisionId
where    t.DistrictId = @id
	   
    END


 

