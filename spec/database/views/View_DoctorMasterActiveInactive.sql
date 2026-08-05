









CREATE VIEW [dbo].[View_DoctorMasterActiveInactive]
 
AS
SELECT DISTINCT CM.DoctorId ,
                CM.DoctorCode ,
                (CM.DoctorCode + ' : '+CM.DoctorName)AS DoctorName, 
				 
								(
				SELECT TOP 1 Contact FROM dbo.tblDoctorContactDetail  with (nolock) WHERE  DoctorId = CM.DoctorId
				) AS DocContact ,dt.DoctorTypeName, pt.ProgramTypeName,  STUFF( (SELECT CONCAT('; ', mm.Name  , '') FROM dbo.tblDoctorChemberDetail mm  with (nolock)  WHERE mm.DoctorId=CM.DoctorId ORDER BY mm.ChemberId FOR XML PATH ('') ),1,1,'') AS ChemberName, M.MarketId, M.MarketCode, M.MarketName, ST.SubTerritoryId, ST.SubTerritoryName, ST.SubTerritoryCode, ST.SubTerritoryShortName, T.TerritoryId, T.TerritoryName, T.TerritoryCode, T.TerShortName, 
             T.Description, A.AreaCode, A.AreaName, A.AreaId, R.RegionId, R.RegionCode, R.RegionName, G.GroupId, G.GroupName,  STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm (NOLOCK) INNER JOIN dbo.tblDoctorDegreeDetail mgd  with (nolock) ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=CM.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS DegreeName,  STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm  with (nolock) INNER JOIN dbo.tblDoctorSpecialityDetail mgd  with (nolock) ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=CM.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,'') as DoctorSpeciality  
FROM   dbo.tblDoctorMaster AS CM with (nolock)
LEFT JOIN dbo.tblDoctorType  dt  with (nolock) ON CM.DoctorTypeId=dt.DoctorTypeId
						LEFT JOIN dbo.tblProgramType pt  with (nolock) ON CM.ProgramTypeId=pt.ProgramTypeId
 INNER JOIN
             dbo.tblMarket AS M  with (nolock) ON M.MarketId = REPLACE(CM.MarketId, ' ', '') INNER JOIN
             dbo.tblSubTerritory AS ST  with (nolock) ON ST.SubTerritoryId = M.SubTerritoryId  INNER JOIN
             dbo.tblTerritory AS T  with (nolock) ON T.TerritoryId = ST.TerritoryId INNER JOIN
             dbo.tblArea AS A  with (nolock) ON A.AreaId = REPLACE(T.AreaId, ' ', '') INNER JOIN
             dbo.tblRegion AS R  with (nolock) ON R.RegionId = REPLACE(A.RegionId, ' ', '')  INNER JOIN
             dbo.tbl_Group AS G  with (nolock) ON G.GroupId = R.GroupId 
	  






