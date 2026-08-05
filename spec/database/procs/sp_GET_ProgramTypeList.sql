
create PROCEDURE [dbo].[sp_GET_ProgramTypeList]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT *
	FROM dbo.tblProgramType AS GRP WITH (NOLOCK) where IsActive=1 


 END
