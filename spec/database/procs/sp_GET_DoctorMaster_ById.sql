

 CREATE PROCEDURE [dbo].[sp_GET_DoctorMaster_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select mas.ProgramTypeId, dChem.ChamberTypeId ChamberTypeId, dChemT.chamberName ChamberTypeName , dChem.Name ChamberName, dChem.Phone Phone,dchem.Address ChamberAddress, STUFF( (SELECT CONCAT(',', brn.BrandId , '') FROM dbo.tblDoctorBrandDetail brn(NOLOCK)  WHERE brn.DoctorId=mas.DoctorId ORDER BY brn.BrandId FOR XML PATH ('') ),1,1,'') AS BrandId, STUFF( (SELECT CONCAT(',', mgd.DegId , '') FROM dbo.tblDoctorDegreeDetail mgd(NOLOCK)  WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS DegreeId,  STUFF( (SELECT CONCAT(',', mgd.SpecialityId , '') FROM dbo.tblDoctorSpecialityDetail mgd (NOLOCK)   WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,'') as DoctorSpecialityId ,  STUFF( (SELECT CONCAT(',', mgd.ProgramTypeId , '') FROM dbo.tblDoctorProgramTypeDetail mgd with (NOLOCK)  WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd. DoctorTypeDetailId FOR XML PATH ('') ),1,1,'') as ProgramTypeId, mas.MarketId,subTr.SubTerritoryId, Tr.TerritoryId, Ar.AreaId, rg.RegionId,gr.GroupId,   mas.* from tblDoctorMaster mas with (nolock)
	 
	
	 left join  tblMarket mr on mas.MarketId=mr.MarketId
	 left join  tblSubTerritory subTr on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr on gr.GroupId=rg.GroupId

	 left join  tblDoctorChemberDetail  dChem on dChem.DoctorId=mas.DoctorId
	 left join  tblDoctorChamber  dChemT on dChemT.ChamberId=dChem.ChamberTypeId








	  where mas.DoctorId = @id
      
    END


