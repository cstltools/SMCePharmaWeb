
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_CustMasterList_ApproveTest]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
 SELECT top 20 case when mas.ActionStatus=''0'' then ''Pending''  when mas.ActionStatus=''1'' then ''Verified'' when mas.ActionStatus=''2'' then ''Approved'' when mas.ActionStatus=''3'' then ''Rejected''  else mas.ActionStatus end ApprovalStatus, pt.ProgramTypeName,  mr.MarketName,  Chmist.CustomerType,DR.RouteName  DistributionRouteName, * from dbo.tblCustMaster mas WITH (NOLOCK) 
 LEFT JOIN dbo.tblCustomerType Chmist  WITH (NOLOCK)  ON Chmist.CustomerTypeId = mas.CustomerTypeId
 LEFT JOIN dbo.tblProgramType pt  WITH (NOLOCK)  ON pt.ProgramTypeId = mas.ProgramTypeId
  LEFT JOIN dbo.tblRouteInformationMaster DR  WITH (NOLOCK)  ON DR.RouteInformationMasterId = mas.DistributionRouteId
  left join  tblMarket mr on mas.MarketId=mr.MarketId
	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
 
   where mas.CustomerMasterId is not null
  '+@Parm +'  order by CustomerCode desc '


EXEC sp_executesql @Q
	
END