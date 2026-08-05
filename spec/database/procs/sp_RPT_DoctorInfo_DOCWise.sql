
create PROCEDURE [dbo].[sp_RPT_DoctorInfo_DOCWise]
	-- Add the parameters for the stored procedure here
   @Parameter NVARCHAR(max)

AS
    BEGIN

	--DECLARE @Query NVARCHAR(MAX)
		--SET @Query = '

SELECT RG.RegionName,AR.AreaName,EMP.EmpName MIO,
0 as  DoctorName, 0 as  Provider, 0 as DoctorType, 0 as Degree, 0 Speciality,
0 AS RepeatVisit, 0 AS Prescription,
0 as W1visit, 0 AS W1Pres,
0 as W2visit, 0 AS W2Pres,  
0 as W3visit, 0 AS W3Pres,  
0 as W4visit, 0 AS W4Pres
FROM tblMIOInfo MIO  
LEFT JOIN tblEmpGeneralInfo EMP ON MIO.EmployeeId = EMP.EmpInfoId
LEFT JOIN tblTerritory TE ON MIO.TerritoryId = TE.TerritoryId
LEFT JOIN tblArea AR ON Te.AreaId  = AR.AreaId
LEFT JOIN tblRegion  RG ON  AR.RegionId = RG.RegionId
WHERE MIO.MIOId IS NOT NULL  ORDER BY RG.RegionId 

    END