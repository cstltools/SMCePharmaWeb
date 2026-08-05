
CREATE PROCEDURE [dbo].[sp_Webapi_Get_PrescriptionByPrescriptionIdId]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN 
  SELECT  (SELECT LTRIM(RTRIM(ImagePath+'/'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType='PresMy')+CAST(mas.PrescriptionId as nvarchar(max))+'.jpg' AS   ImageString, mas.PrescriptionId , 
				 FORMAT(mas.EntryDate,'dd-MMMM-yyyy h:mm tt') PrescriptionDate,
pst.PrescriptionType, gr.GroupName,rg.RegionName,ar.AreaName,tr.TerritoryName, sr.SubTerritoryName, mr.MarketName , chm.Name ChemberName,doc.DoctorCode+' - '+doc.DoctorName DoctorName,mas.DoctorId
                 
        FROM    tbl_PrescriptionMaster mas   with (nolock) 
left join tblDoctorMaster doc  with (nolock)  on mas.DoctorId=doc.DoctorId

				left join tblDoctorChemberDetail chm  with (nolock)  on mas.ChemberId=chm.ChemberId
		left join tbl_PrescriptionType pst  with (nolock) on pst.PrescriptionTypeId=mas.PrescriptionTypeId
 

left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mas.SubTerritoryId
		left join tblTerritory tr  with (nolock) on mas.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=mas.AreaId
		left join tblRegion rg  with (nolock) on mas.RegionId=rg.RegionId
		left join tblMarket mr  with (nolock) on mr.MarketId=mas.MarketId
		left join tbl_Group gr  with (nolock) on gr.GroupId=mas.GroupId

         
                where mas.PrescriptionId = @id
END




