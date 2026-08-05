
create PROCEDURE [dbo].[sp_RPT_DoctorInfo_MIOWise]
	-- Add the parameters for the stored procedure here
   @Parameter NVARCHAR(max)

AS
    BEGIN

	--DECLARE @Query NVARCHAR(MAX)
		--SET @Query = '


SELECT RG.RegionName,AR.AreaName,EMP.EmpName MIO, 0 as  totalDocAssign, 0 as  totalDocVisited, 0 as totalDocRepect, 0 as totalDocPreas, 
0 as W1visit, 0 As W1Repect, 0 AS W1Pres,
0 as W2visit, 0 As W2Repect, 0 AS W2Pres,  
0 as W3visit, 0 As W3Repect, 0 AS W3Pres,  
0 as W4visit, 0 As W5Repect, 0 AS W6Pres
FROM tblMIOInfo MIO  
LEFT JOIN tblEmpGeneralInfo EMP ON MIO.EmployeeId = EMP.EmpInfoId
LEFT JOIN tblTerritory TE ON MIO.TerritoryId = TE.TerritoryId
LEFT JOIN tblArea AR ON Te.AreaId  = AR.AreaId
LEFT JOIN tblRegion  RG ON  AR.RegionId = RG.RegionId
WHERE MIO.MIOId IS NOT NULL  ORDER BY RG.RegionId 

    END
