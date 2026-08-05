CREATE PROCEDURE [dbo].[sp_CS_MIOInfo_BySC]
	-- Add the parameters for the stored procedure here
	@DCId int
AS
BEGIN
 

			 
		SELECT Distinct mas.MIOId ValueId,emp.EmpMasterCode+' : '+  CASE WHEN mas.IsActive=1 THEN   emp.EmpName  ELSE   emp.EmpName+' (Inactive)' END+' [Terr: '+ tr.TerritoryCode+' : '+tr.TerritoryName+']'  TextName  FROM dbo.tblMIOInfo mas  with(nolock)
		INNER JOIN dbo.tblEmpGeneralInfo emp ON mas.EmployeeId=emp.EmpInfoId
		INNER JOIN dbo.tblTerritory tr ON mas.TerritoryId=tr.TerritoryId

		INNER JOIN dbo.tblRouteInformationMarketDetail raDtl ON raDtl.TerritoryId=mas.TerritoryId
		INNER JOIN dbo.tblRouteInformationMaster ra ON ra.RouteInformationMasterId=raDtl.RouteInformationMasterId




		where   ra.DCId=@DCId

	
END
