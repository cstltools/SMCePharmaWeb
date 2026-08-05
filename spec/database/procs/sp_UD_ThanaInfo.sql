 create PROCEDURE [dbo].[sp_UD_ThanaInfo]
	-- Add the parameters for the stored procedure here
    @id int ,
    @district_id INT,
	@ThanaName  NVARCHAR(MAX),
    @UpdateBy  INT

AS


BEGIN


   UPDATE tbl_Thana  SET 
   district_id = @district_id,
   ThanaName = @ThanaName 
   
   Where ThanaId = @id


END
