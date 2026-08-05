
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DCRInfoListbyDcrId]
	-- Add the parameters for the stored procedure here
	@DcrId int
AS
BEGIN 

SELECT mas.DcrId, doc.DoctorCode+' : '+doc.DoctorName DoctorName, FORMAT(mas.DcrDate,'dd-MMM-yyyy hh:mm tt') DcrDate, vt.VisitTypeName,chm.Name ChemberName, mas.Remarks, case when IsNonEffectiveReason=1 then 'Yes' else 'No' end NonEffectiveReason, rsn.ReasonName, gr.GroupName,rg.RegionName,ar.AreaName,tr.TerritoryName, sr.SubTerritoryName, mr.MarketName, mas.DoctorId , mas.*   from tbl_DCRInfo mas  with (nolock)

left join tbl_DoctorVisitType vt   with (nolock)  on mas.TourTypeId=vt.DocVisitTypeId
left join tblDoctorChemberDetail chm   with (nolock)  on mas.ChemberId=chm.ChemberId
left join tblNonEffectiveReason rsn   with (nolock)  on mas.ReasonId=rsn.ReasonId
left join tblDoctorMaster doc   with (nolock)  on mas.DoctorId=doc.DoctorId

left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mas.SubTerritoryId
		left join tblTerritory tr  with (nolock) on mas.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=mas.AreaId
		left join tblRegion rg  with (nolock) on mas.RegionId=rg.RegionId
		left join tblMarket mr  with (nolock) on mr.MarketId=mas.MarketId
		left join tbl_Group gr  with (nolock) on gr.GroupId=mas.GroupId


		 

	 

where mas.DcrId=@DcrId
END





