
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_OrderDelTrackingList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
 SELECT   FORMAT(mas.DelDate,''dd MMM, yyyy hh:mm tt'') DelDate, case when  DelEmp.EmpInfoId is null then usDel.LoginName else DelEmp.EmpMasterCode+'' : ''+DelEmp.EmpName end  DELEmpName,  mas.OrderId, mas.OrderCode, mas.GrossValue,mas.TotalVat,mas.TotalDiscount, mas.TotalNetPayable,  mas.OrderSenderCode+ '' : ''+mas.OrderSenderName CreateBy,  case when mas.ActionStatus=''0'' then ''Pending''  when mas.ActionStatus=''1'' then ''Verified'' when mas.ActionStatus=''2'' then ''Approved'' when mas.ActionStatus=''3'' then ''Rejected''  else mas.ActionStatus end ApprovalStatus, FORMAT(mas.ServerDateTime,''dd-MMM-yyyy hh:mm tt'') SubmissionDate, DZSM.EmpMasterCode+'' : ''+DZSM.EmpName DZSMEmpName, AM.EmpMasterCode+'' : ''+AM.EmpName AMEmpName,MIO.EmpMasterCode+'' : ''+MIO.EmpName MIOEmpName,  gr.GroupCode GroupName, rg.RegionCode RegionName,ar.AreaCode AreaName,tr.TerritoryCode,tr.TerritoryName TerritoryName,sr. SubTerritoryCode+'' : ''+sr.SubTerritoryName SubTerritoryName,mr.MarketCode+'' : ''+mr.MarketName MarketName,rt.RouteName, * FROM dbo.tblOrderDel mas WITH (NOLOCK)

LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 
		left join tblmarket mr   with (nolock) on mr.MarketId=mas.MarketId
		left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mas.SubTerritoryId
		left join tblTerritory tr  with (nolock) on mas.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=mas.AreaId
		left join tblRegion rg  with (nolock) on mas.RegionId=rg.RegionId
		left join dbo.tbl_Group gr  with (nolock) on mas.GroupId=gr.GroupId
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
			left join dbo.tblUser usDel  with (nolock) on mas.DelBy=usDel.UserId
LEFT JOIN dbo.tblEmpGeneralInfo DelEmp  with (nolock)  ON usDel.EmpInfoId=DelEmp.EmpInfoId
		 WHERE OrderId IS NOT NULL
  '+@Parm +'   order by mas.DelDate desc '


EXEC sp_executesql @Q
	
END