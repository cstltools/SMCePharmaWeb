
create PROCEDURE [dbo].[sp_GET_ActionStatusList]
	-- Add the parameters for the stored procedure here
 

AS
    BEGIN

	SELECT WebShow,SoftwareUseId
	FROM dbo.tblActionStatus AS GRP WITH (NOLOCK) where IsActive=1 


 END
