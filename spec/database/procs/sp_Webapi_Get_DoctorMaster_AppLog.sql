
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorMaster_AppLog]
	-- Add the parameters for the stored procedure here
	@DoctorId int
AS
BEGIN
SELECT mas.DoctorAddress, rg.RegionName, mas.StationTypeId, sr.SubTerritoryId, tr.TerritoryId, cttype.ContactType, ct.ContactTypeId,  ct.Contact,  mas.DoctorId, mas.DoctorName, mas.DoctorCode, dgs.DesignationName, mas.DesignationId, dt.DoctorTypeName, mas.DoctorTypeId,  STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm (NOLOCK) INNER JOIN dbo.tblDoctorDegreeDetail mgd ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS DegreeName, STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm (NOLOCK) INNER JOIN dbo.tblDoctorSpecialityDetail mgd ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,'') as DoctorSpeciality , STUFF( (SELECT CONCAT(',', insMas.Institution , '') FROM tblInstitutionInfo insMas (NOLOCK) INNER JOIN dbo.tblDoctorInstitutionDetail mgd ON mgd.InstitutionId=insMas.InstitutionId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.InstitutionId FOR XML PATH ('') ),1,1,'') as DoctorInstitution , STUFF( (SELECT CONCAT(',', insMas.ProductSQName , '') FROM tblProductSQ insMas (NOLOCK) INNER JOIN dbo.tblDoctorBrandDetail mgd ON mgd.BrandId=insMas.ProductBrandId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorBrandId FOR XML PATH ('') ),1,1,'') as DoctorBrand, cat.CategoryName, mas.DoctorCategoryId, pt.ProgramTypeName, mas.ProgramTypeId, mas.SpecialDayId, sd.SpecialDay, mas.SpeciaDateStr, ar.AreaName,tr.TerritoryCode+' : '+  tr.TerritoryName TerritoryName,sr.SubTerritoryName, mas.MarketId, mr.MarketName, mas.Reamrks,sType.SMCType,mas.SMCTypeId from tblDoctorMaster mas  with (nolock)
left join tblStationType  st on mas.StationTypeId=st.StationTypeId
left join tblProgramType  pt on mas.ProgramTypeId=pt.ProgramTypeId
left join tblDoctorSpecialDay  sd on mas.SpecialDayId=sd.SpecialDayId
left join tblDoctorType  dt on mas.DoctorTypeId=dt.DoctorTypeId
left join tblDoctorCategory  cat on mas.DoctorCategoryId=cat.CategoryId
left join tblDoctorContactDetail  ct on mas.DoctorId=ct.DoctorId
left join dbo.tbl_ContactType  cttype on cttype.ContactTypeId=ct.ContactTypeId

 



  Left Join dbo.tblDoctorDesignation dgs  with (NOLOCK)  ON dgs.DesignationId= mas.DesignationId

  
		Left join tblmarket mr  with (nolock) on mr.MarketId=mas.MarketId

		Left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		Left join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		Left join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		Left join dbo.tblRegion rg   with (nolock)  on ar.RegionId=rg.RegionId
		    left JOIN dbo.TblSmcType sType  with (nolock)  ON sType.SMCTypeId = mas.SMCTypeId

where mas.DoctorId=@DoctorId
END





