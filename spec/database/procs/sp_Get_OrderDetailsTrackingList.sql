
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_OrderDetailsTrackingList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
 SELECT  gr.GroupCode,rg.RegionCode,ar.AreaCode,sr.SubTerritoryCode,mr.MarketCode,ORDRD.CampaignName as CampaignName2,mas.OrderId, mas.OrderCode,  mas.OrderSenderCode+ '' : ''+mas.OrderSenderName CreateBy,  case when mas.ActionStatus=''0'' then ''Pending''  when mas.ActionStatus=''1'' then ''Verified'' when mas.ActionStatus=''2'' then ''Approved'' when mas.ActionStatus=''3'' then ''Rejected''  else mas.ActionStatus end ApprovalStatus, FORMAT(mas.ServerDateTime,''dd-MMM-yyyy hh:mm tt'') SubmissionDate, DZSM.EmpMasterCode+'' : ''+DZSM.EmpName DZSMEmpName, AM.EmpMasterCode+'' : ''+AM.EmpName AMEmpName,MIO.EmpMasterCode+'' : ''+MIO.EmpName MIOEmpName, gr.GroupName, rg.RegionName,ar.AreaName,tr.TerritoryCode,tr.TerritoryName TerritoryName,sr.SubTerritoryName,mr.MarketName,rt.RouteName, ComUnitName ,
CustomerCode,
CustomerName,
ProductCode,
ProductName,
Quantity,
TradePrice,
TotalTradePrice,
UnitVatAmount,
TotalVatAmount,
DiscountPercent,
DiscountAmount,
NetAmount,
ISGiftProduct FROM dbo.tblOrder mas WITH (NOLOCK)

LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 LEFT JOIN dbo.tbluser us  with (nolock)  ON mas.EntryBy=us.UserId

 
 LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = us.EmpInfoId
		left join tblmarket mr   with (nolock) on mr.MarketId=mas.MarketId
		left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mas.SubTerritoryId
		left join tblTerritory tr  with (nolock) on mas.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=mas.AreaId
		left join tblRegion rg  with (nolock) on mas.RegionId=rg.RegionId
		left join dbo.tbl_Group gr  with (nolock) on mas.GroupId=gr.GroupId
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
		  INNER JOIN tblOrderDetail AS ORDRD with (nolock) ON mas.OrderId = ORDRD.OrderId
		 WHERE mas.OrderId IS NOT NULL
  '+@Parm +'   order by mas.OrderCode desc '


EXEC sp_executesql @Q
	
END