
CREATE PROCEDURE [dbo].[sp_Get_CustomerTranferApprovalList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)
AS
BEGIN
    select mas.CustMaster_TranferLogId MasterID, mas.Marketid, rg.RegionCode, Ar.AreaCode, Tr.TerritoryCode,case when mas.ActionStatus='0' then 'Pending'  when mas.ActionStatus='1' then 'Verified' when mas.ActionStatus='2' then 'Approved' when mas.ActionStatus='3' then 'Rejected'  else mas.ActionStatus end ApprovalStatus, pt.ProgramTypeName, mr.MarketCode,mr.MarketName MarketName,  Chmist.CustomerType,dcMas.RouteName  DistributionRouteName,  * from tblCustMaster_TranferLog  mas WITH (NOLOCK) 

	LEFT JOIN dbo.tblCustomerType Chmist  WITH (NOLOCK)  ON Chmist.CustomerTypeId = mas.CustomerTypeId
 LEFT JOIN dbo.tblProgramType pt  WITH (NOLOCK)  ON pt.ProgramTypeId = mas.ProgramTypeId
   
  left join  tblMarket mr  WITH (NOLOCK)  on mas.MarketId=mr.MarketId
	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
     left JOIN tblRouteInformationMarketDetail DCdtl  with (nolock) on mas.MarketId=DCdtl.MarketId
		left join tblRouteInformationMaster dcMas  with (nolock) on dcMas.RouteInformationMasterId=DCdtl.RouteInformationMasterId
   where mas.CustomerMasterId is not null and mas.TranferBy is null
    order by CustomerCode desc
END
