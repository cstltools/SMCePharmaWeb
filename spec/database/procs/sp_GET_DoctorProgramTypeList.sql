
create PROCEDURE [dbo].[sp_GET_DoctorProgramTypeList]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT *
	FROM dbo.tblDoctorProgramType AS GRP WITH (NOLOCK) where IsActive=1 


 END
