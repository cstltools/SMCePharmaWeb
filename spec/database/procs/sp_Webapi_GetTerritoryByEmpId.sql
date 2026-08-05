CREATE PROCEDURE [dbo].[sp_Webapi_GetTerritoryByEmpId]
	-- Add the parameters for the stored procedure here
@empId INT = NULL
AS
BEGIN
		
		SELECT TerritoryId ,
               TerritoryName ,
               TerritoryCode 
			   FROM dbo.tblTerritory WHERE IsActive = 1 AND TerritoryId IN (
		SELECT TerritoryId FROM dbo.tblMIOInfo WHERE EmployeeId = @empId AND IsActive = 1
		)
		 

END
