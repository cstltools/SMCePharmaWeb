CREATE PROCEDURE [dbo].[sp_GET_SubDepotByComUnitId]
	
	-- Add the parameters for the stored procedure here
	@ComUnitId INT

AS
BEGIN

	SELECT SubDepotId,SubDepotCode + ':' + SubDepotName AS SubDepotName 
	FROM tblSubDepot  WITH (nolock)
 WHERE ComUnitId = @ComUnitId

END

