
create PROCEDURE [dbo].[sp_GET_SMCTypeListParm]
	-- Add the parameters for the stored procedure here
  
  @Parm nvarchar(max)
AS
    BEGIN

 DECLARE @Q NVARCHAR(MAX)='	SELECT *
	FROM dbo.tblSMCType AS GRP WITH (NOLOCK) where IsActive=1  '  +@Parm 

	EXEC sp_executesql @Q
 END
