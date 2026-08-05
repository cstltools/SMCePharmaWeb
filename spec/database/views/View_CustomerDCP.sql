













CREATE VIEW [dbo].[View_CustomerDCP]
 
AS
   
 select  distinct  doc.RegionId,doc.AreaId,doc.TerritoryId,mas.ApprovalStatus,   doc.DoctorId, CONVERT(date,DOC.TourPlanDate)  DcrDate,  DocMas.CustomerCode [Doctor Code],      DocMas.CustomerName [Doctor Name],STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=DOC.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS [Degree Name],ISNULL(STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=DOC.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,''),'') as [Doctor Speciality], '' [Provider Type] , case when  doc.SMCType_DV is null then 'N/A' else  doc.SMCType_DV end [Pharma Platform] ,  ''  [Doctor Type] ,doc.GroupName_DV  [Group], doc.RegionCode_DV  [Region],doc.AreaCode_DV  [Area],doc.TerritoryCode_DV  [Territory],doc.SubTerritoryCode_DV +' : '+ doc.SubTerritoryName_DV [Sub-Territory],doc.MarketCode_DV  [Market] from tbl_DoctorTourPlanMaster  mas   WITH (NOLOCK) 
 inner join tbl_DoctorTourPlanDetail doc  WITH (NOLOCK)    on mas.DocTPMaster=DOC.DocTPMaster
  inner join tblCustMaster DocMas  with (nolock)  on  DOC.DoctorId=DocMas.CustomerMasterId  where doc.Type_DV='C'
 

 



