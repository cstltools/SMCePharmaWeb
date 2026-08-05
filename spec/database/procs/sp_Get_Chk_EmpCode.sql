CREATE PROCEDURE [dbo].[sp_Get_Chk_EmpCode]
	-- Add the parameters for the stored procedure here
	@EmpCode nvarchar(max)  

AS
BEGIN


  select TerritoryCode from tblEmpGeneralInfo eg
   left join tblMIOInfo mo on mo.EmployeeId=eg.EmpInfoId
   left join tblTerritory tr on mo.TerritoryId=tr.TerritoryId

  where LTRIM(RTRIM(tr.TerritoryCode))= LTRIM(RTRIM(@EmpCode)) --and tr.IsActive=1  --and mo.IsActive=1


   

  end 

			  