
create PROCEDURE [dbo].[sp_GET_ProgramTypeListParm]
	-- Add the parameters for the stored procedure here
  
  @Parm nvarchar(max)
AS
    BEGIN

 DECLARE @Q NVARCHAR(MAX)='	SELECT *
	FROM dbo.tblProgramType AS GRP WITH (NOLOCK) where IsActive=1  '  +@Parm 

	EXEC sp_executesql @Q
 END
