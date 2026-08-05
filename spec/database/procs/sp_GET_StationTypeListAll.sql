
create PROCEDURE [dbo].[sp_GET_StationTypeListAll]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT *
	FROM dbo.tblStationType AS GRP WITH (NOLOCK)  


 END
