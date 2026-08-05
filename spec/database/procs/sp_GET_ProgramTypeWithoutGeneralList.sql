
create PROCEDURE [dbo].[sp_GET_ProgramTypeWithoutGeneralList]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT *
	FROM dbo.tblProgramType AS GRP WITH (NOLOCK) where IsActive=1  and ProgramTypeId<>4


 END
