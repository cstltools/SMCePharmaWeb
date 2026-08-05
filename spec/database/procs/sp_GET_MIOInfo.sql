-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_MIOInfo]
	
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   

   DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'SELECT  RGN.Sap_Code RegionSap_Code, ARA.Sap_Code AreaSap_Code,  TTR.Sap_Code TerritorySap_Code, MIO.MIOId,RGN.RegionCode + '':''+ RGN.RegionName AS Region,
   ARA.AreaCode + '':''+ ARA.AreaName AS Area,
   TTR.TerritoryCode + '':''+ TTR.TerritoryName AS Territory,
   EGI.EmpMasterCode + '':''+ EGI.EmpName AS EmployeeName,
   MIO.IsActive,CONVERT(NVARCHAR(50),MIO.ActiveInActiveDate,106)AS ActiveInActiveDate,
   CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus FROM tblMIOInfo AS MIO
   LEFT JOIN tblTerritory AS TTR ON MIO.TerritoryId = TTR.TerritoryId
   LEFT JOIN tblArea AS ARA ON ARA.AreaId = TTR.AreaId
   LEFT JOIN tblRegion AS RGN ON RGN.RegionId = ARA.RegionId
   LEFT JOIN tblEmpGeneralInfo AS EGI ON MIO.EmployeeId = EGI.EmpInfoId 
   LEFT JOIN (SELECT DISTINCT MIOId,COUNT(MIOId) NoOf FROM tblOrder GROUP BY MIOId) AS C ON MIO.MIOId = C.MIOId
   WHERE MIO.MIOId IS NOT NULL  ' + @Parameter

   EXEC(@Query)


   --SELECT MIO.MIOId, RGN.RegionId,RGN.RegionCode + ':'+ RGN.RegionName AS Region,
   --ARA.AreaCode + ':'+ ARA.AreaName AS Area,
   --TTR.TerritoryCode + ':'+ ARA.AreaName AS Area,
   --EGI.EmpMasterCode + ':'+ EGI.EmpName AS EmployeeName,
   --MIO.IsActive,CONVERT(NVARCHAR(50),MIO.ActiveDate,106)AS ActiveInActiveDate,
   --CASE WHEN ISNULL(C.NoOf,0) > 0 THEN 'disabled' ELSE '' END AS DeleteStatus
   --FROM tblMioInfo AS MIO
   --LEFT JOIN tblArea AS ARA ON ARA.AreaId = ASM.AreaId
   --LEFT JOIN tblRegion AS RGN ON RGN.RegionId = ARA.RegionId
   --LEFT JOIN tblEmpGeneralInfo AS EGI ON ASM.EmployeeId = EGI.EmpInfoId 
   --LEFT JOIN (SELECT DISTINCT MIOId,COUNT(MIOId) NoOf FROM tblOrder GROUP BY MIOId) AS C ON MIO.MIOId = C.MIOId
   --WHERE MIO.MIOId IS NOT NULL 


   --SELECT MIO.MIOId,RGN.RegionCode + ':'+ RGN.RegionName AS Region,
   --ARA.AreaCode + ':'+ ARA.AreaName AS Area,
   --TTR.TerritoryCode + ':'+ TTR.TerritoryName AS Territory,
   --EGI.EmpMasterCode + ':'+ EGI.EmpName AS EmployeeName,
   --MIO.IsActive,CONVERT(NVARCHAR(50),MIO.ActiveDate,106)AS ActiveInActiveDate,
   --CASE WHEN ISNULL(C.NoOf,0) > 0 THEN 'disabled' ELSE '' END AS DeleteStatus FROM tblMIOInfo AS MIO
   --LEFT JOIN tblTerritory AS TTR ON MIO.TerritoryId = TTR.TerritoryId
   --LEFT JOIN tblArea AS ARA ON ARA.AreaId = TTR.AreaId
   --LEFT JOIN tblRegion AS RGN ON RGN.RegionId = ARA.RegionId
   --LEFT JOIN tblEmpGeneralInfo AS EGI ON MIO.EmployeeId = EGI.EmpInfoId 
   --LEFT JOIN (SELECT DISTINCT MIOId,COUNT(MIOId) NoOf FROM tblOrder GROUP BY MIOId) AS C ON MIO.MIOId = C.MIOId
   --WHERE MIO.MIOId IS NOT NULL 

   --SELECT DISTINCT MIOId,COUNT(MIOId) NoOf FROM tblOrder GROUP BY MIOId
   

   

 
END
