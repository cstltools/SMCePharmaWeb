CREATE PROCEDURE [dbo].[sp_Get_SAP_EmpSApCodebyTerritory]
	-- Add the parameters for the stored procedure here
	@TerritoryCode nvarchar(max)  

AS
BEGIN


  
  select e.SAPEmpCode SAP_MIOCode,tr.TerritoryName ,   * from tblMIOInfo c
  inner join tblTerritory tr on tr.TerritoryId=c.TerritoryId
  inner join tblEmpGeneralInfo e on e.EmpInfoId=c.EmployeeId
  where   e.EmpMasterCode=ltrim(rtrim(@TerritoryCode))

  --select e.SAPEmpCode SAP_MIOCode,tr.TerritoryName ,   * from tblMIOInfo c
  --inner join tblTerritory tr on tr.TerritoryId=c.TerritoryId
  --inner join tblEmpGeneralInfo e on e.EmpInfoId=c.EmployeeId
  --where c.IsActive=1 and tr.IsActive=1 and   e.EmpMasterCode=ltrim(rtrim(@TerritoryCode))
 

  end 

			  