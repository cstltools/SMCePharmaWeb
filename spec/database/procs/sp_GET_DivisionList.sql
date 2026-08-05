
create PROCEDURE [dbo].[sp_GET_DivisionList]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT *
	FROM dbo.tbl_Division AS GRP WITH (NOLOCK)


 END
