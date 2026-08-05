
CREATE PROCEDURE [dbo].[sp_GET_ThanaList]
	-- Add the parameters for the stored procedure here
  @id int 

AS
    BEGIN

	SELECT *
	FROM dbo.tbl_Thana AS GRP WITH (NOLOCK) where IsActive=1 and district_id=@id


 END
