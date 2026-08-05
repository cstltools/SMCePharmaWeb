create PROCEDURE [dbo].[sp_Get_TerritoryTargetList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
 SELECT case when A.TerritoryId is null then A.TerritoryCode else  tr.TerritoryCode+ '' : ''+ tr.TerritoryName end TerritoryName, dgs.DesigName, (SELECT dbo.MonthValueToName(A.MonthName) AS MonthName) Month_Name, A.* from dbo.tblTerritoryDataMigration A WITH (NOLOCK)
 LEFT JOIN dbo.tblEmpGeneralInfo emp  WITH (NOLOCK) ON emp.EmpInfoId = A.EmpId
 LEFT JOIN dbo.tblDesignation dgs  WITH (NOLOCK) ON dgs.DesignationId = emp.DesignationId
 left join tblTerritory tr   WITH (NOLOCK) on tr.TerritoryId=A.TerritoryId
 where A.SL is not null 
 '+@Parm +'    order by    A.YearValue desc,A.MonthName  asc, A.TerritoryCode asc
  '


EXEC sp_executesql @Q
	
END