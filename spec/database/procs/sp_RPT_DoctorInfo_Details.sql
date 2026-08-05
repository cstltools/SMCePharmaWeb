
create PROCEDURE [dbo].[sp_RPT_DoctorInfo_Details]
	-- Add the parameters for the stored procedure here
   @Parameter NVARCHAR(max)

AS
    BEGIN


SELECT RG.RegionName,AR.AreaName,EMP.EmpName MIO,
'' as  DoctorName, '' as  Provider, '' as DoctorType, '' as Degree, '' Speciality,

0 as W1DCP, 0 AS W1DCR,  0 AS W1RX,
0 as W2DCP, 0 AS W2DCR,   0 AS W2RX,
0 as W3DCP, 0 AS W3DCR,  0 AS W3RX, 
0 as W4DCP, 0 AS W4DCR, 0 AS W4RX,
0 As totalDCP, 0 as TotalDCR, 0 as TotalRX 
FROM tblMIOInfo MIO  
LEFT JOIN tblEmpGeneralInfo EMP ON MIO.EmployeeId = EMP.EmpInfoId
LEFT JOIN tblTerritory TE ON MIO.TerritoryId = TE.TerritoryId
LEFT JOIN tblArea AR ON Te.AreaId  = AR.AreaId
LEFT JOIN tblRegion  RG ON  AR.RegionId = RG.RegionId
WHERE MIO.MIOId IS NOT NULL  ORDER BY RG.RegionId 

    END
