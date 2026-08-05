-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='
   SELECT   STUFF((SELECT  CASE   WHEN dChemT.chamberName IS NOT NULL THEN   CHAR(10) + '' Chamber Type: '' + dChemT.chamberName ELSE ''''  END +  CASE  WHEN dChem.Name IS NOT NULL THEN '', Chamber Name: '' + dChem.Name
                    ELSE ''''  END + CASE  WHEN dChem.Phone IS NOT NULL THEN '', Chamber Phone: '' + dChem.Phone
                    ELSE '''' END +  CASE   WHEN dChem.Address IS NOT NULL THEN '', Chamber Address: '' + dChem.Address  ELSE '''' END FROM tblDoctorChemberDetail dChem  WITH (NOLOCK)  LEFT JOIN tblDoctorChamber dChemT  WITH (NOLOCK)  ON dChemT.ChamberId = dChem.ChamberTypeId  WHERE dChem.DoctorId=DM.DoctorId
           FOR XML PATH('''')), 1, 2, '''') AS ChamberInfo, tblcom.Dept, tblMIO.StationTypeName , St.SMCType,STUFF( (SELECT CONCAT('','', mm.Contact , '''') FROM tblDoctorContactDetail mm (NOLOCK)   WHERE mm.DoctorId=DM.DoctorId ORDER BY mm.ContactId FOR XML PATH ('''') ),1,1,'''') AS ContactName,  dt.DoctorTypeName, pt.ProgramTypeName,mr.MarketCode, rg.RegionCode, Ar.AreaCode, Tr.TerritoryCode, case when DM.ApprovalStatus=''0'' then ''Pending''  when DM.ApprovalStatus=''1'' then ''Verified'' when DM.ApprovalStatus=''2'' then ''Approved'' when DM.ApprovalStatus=''3'' then ''Rejected''  else DM.ApprovalStatus end ApprovalStatusWeb,  DM.DoctorId, mr.MarketName, CONVERT(NVARCHAR(50),DM.EntryDate,106)AS EntryDate,  dgs.DesignationName DesigName,     DM.DoctorName,   Us.UserName as UserEntryBy,  Up.UserName UserUpdateBy, STUFF( (SELECT CONCAT('','', mm.DegreeName , '''') FROM tblDoctorDegree mm (NOLOCK) INNER JOIN dbo.tblDoctorDegreeDetail mgd ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('''') ),1,1,'''') AS DegreeName,  STUFF( (SELECT CONCAT('','', mm.SpecialityName , '''') FROM tblDoctorSpeciality mm (NOLOCK) INNER JOIN dbo.tblDoctorSpecialityDetail mgd ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('''') ),1,1,'''') as DoctorSpeciality ,  STUFF( (SELECT CONCAT('','', mm.ProgramType , '''') FROM tblDoctorProgramType mm with (NOLOCK) INNER JOIN dbo.tblDoctorProgramTypeDetail mgd ON mgd.ProgramTypeId=mm.ProgramTypeId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd. DoctorTypeDetailId FOR XML PATH ('''') ),1,1,'''') as ProgramType, * from tblDoctorMaster DM
   Left Join dbo.tblDoctorDesignation dgs  with (NOLOCK)  ON dgs.DesignationId= DM.DesignationId
   Left Join dbo.tblProgramType pt  with (NOLOCK)  ON pt.ProgramTypeId= DM.ProgramTypeId
    Left Join dbo.tblDoctorType dt  with (NOLOCK)  ON dt.DoctorTypeId= DM.DoctorTypeId
   left join  tblMarket mr  WITH (NOLOCK)  on DM.MarketId=mr.MarketId
    LEFT JOIN (select MarketId,st.StationTypeName  from tblMarketStationDetail dtl  WITH (NOLOCK) 
		inner join  tblStationType st  WITH (NOLOCK)  on st.StationTypeId=dtl.StationTypeId 
		 where dtl.UserRoleID=1) tblMIO ON tblMIO.MarketId = mr.MarketId   LEFT JOIN (select dtl.MarketId,com.ComUnitCode+'' : ''+ComUnitName Dept  from tblRouteInformationMarketDetail dtl
		inner join  tblRouteInformationMaster mas on mas.RouteInformationMasterId=dtl.RouteInformationMasterId 
		inner join  tblCompanyUnit com on mas.DCId=com.ComUnitId 
		  ) tblcom ON tblcom.MarketId = mr.MarketId
	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
   left join  tblSMCType  St  WITH (NOLOCK)   on DM.SMCTypeId=St.SMCTypeId
     Left Join tblUser Us  with (NOLOCK)  ON DM.EntryBy= Us.UserId
   Left Join tblUser Up  with (NOLOCK)  ON DM.UpdateBy= Up.UserId  where  DM.DoctorId is not null 
   '+@Parm +' 
  ORDER BY DM.DoctorCode DESC'


EXEC sp_executesql @Q

END

