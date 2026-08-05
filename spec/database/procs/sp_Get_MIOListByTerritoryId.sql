-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_MIOListByTerritoryId]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
   
 
   DECLARE @Query NVARCHAR(MAX)

SET @Query = 'SELECT mas.EmployeeId, emp.EmpMasterCode, emp.EmpName FROM dbo.tblMIOInfo mas  WITH (NOLOCK)
  LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=mas.EmployeeId WHERE mas.TerritoryId='+  @param
 
END

EXEC (@Query)


