
create PROCEDURE [dbo].[sp_GET_ProgramTypeListAll]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT ProgramTypeId, case when IsActive=1 then GRP.ProgramTypeName else  GRP.ProgramTypeName+ ' [Inactive]' end ProgramTypeName
	FROM dbo.tblProgramType AS GRP WITH (NOLOCK)  


 END
