 create PROCEDURE [dbo].[sp_UD_DistictInfo]
	-- Add the parameters for the stored procedure here
    @id int ,
    @district_id INT,
	@ThanaName  NVARCHAR(MAX),
    @UpdateBy  INT

AS


BEGIN


   UPDATE tbl_District  SET 
   DivisionId = @district_id,
   DistrictName = @ThanaName 
   
   Where DistrictId = @id


END
