CREATE PROCEDURE [dbo].[sp_GET_DepotByCompanyId]
	
	-- Add the parameters for the stored procedure here
	@CompanyId INT

AS
BEGIN

	SELECT ComUnitId,ComUnitCode + ' : ' + ComUnitName AS UnitName 
	FROM tblCompanyUnit with (nolock)
	--WHERE CompanyId = @CompanyId

END

