
create PROCEDURE [dbo].[sp_GET_StationTypeList]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT *
	FROM dbo.tblStationType AS GRP WITH (NOLOCK) where IsActive=1 


 END
