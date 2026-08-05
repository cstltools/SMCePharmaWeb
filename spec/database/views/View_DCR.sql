











CREATE VIEW [dbo].[View_DCR]
 
AS
   
 select  distinct  mas.RegionId,mas.AreaId,mas.TerritoryId, mas.ApprovalStatus,   mas.DoctorId, CONVERT(date,mas.DcrDate)  DcrDate,  doc.DoctorCode [Doctor Code],      doc.DoctorName [Doctor Name],STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS [Degree Name],ISNULL(STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,''),'') as [Doctor Speciality], pt.ProgramTypeName [Provider Type] , case when mas.SMCType_DCR is null then 'N/A' else  mas.SMCType_DCR end [Pharma Platform] ,  case when  dt.DoctorTypeName is null then 'N/A' else   dt.DoctorTypeName end  [Doctor Type] ,mas.GroupName  [Group], mas.RegionCode_DCR  [Region],mas.AreaCode_DCR  [Area],mas.TerritoryCode_DCR  [Territory],mas.SubTerritoryCode_DCR +' : '+ mas.SubTerritoryName [Sub-Territory],mas.MarketCode_DCR  [Market] from tbl_DCRInfo mas   WITH (NOLOCK) 
 inner join tblDoctorMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.DoctorId
 left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 left join tblDoctorType dt  WITH (NOLOCK)    on doc.DoctorTypeId=dt.DoctorTypeId
 
  where  mas.TypeDcr='DCR'
   



