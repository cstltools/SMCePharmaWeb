
CREATE PROCEDURE [dbo].[sp_GET_DistrictList]
	-- Add the parameters for the stored procedure here
  @Id int 

AS
    BEGIN

	SELECT *
	FROM dbo.tbl_District AS GRP WITH (NOLOCK) where IsActive=1 and DivisionId=@Id


 END
