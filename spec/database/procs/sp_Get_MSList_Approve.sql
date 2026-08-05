
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_MSList_Approve]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
     
 select mas.MarketStructureTranferId, Far.AreaCode+ ' : '+Far.AreaName FAreaName,Tar.AreaCode+ ' : '+Tar.AreaName TAreaName,Ftr.TerritoryCode+ ' : '+Ftr.TerritoryName FTerritoryName,Ttr.TerritoryCode + ' : '+Ttr.TerritoryName TTerritoryName,Fsubtr.SubTerritoryCode + ' : '+ Fsubtr.SubTerritoryName FSubTerritoryName , Tsubtr.SubTerritoryCode+ ' : '+Tsubtr.SubTerritoryName TSubTerritoryName,mar.MarketCode+ ' : '+ mar.MarketName  MarketName from tblMarketStructureTranfer mas with (nolock)
	left join tblSubTerritory Fsubtr  with (nolock) on Fsubtr.SubTerritoryId =mas.FSubTerritoryId

	left join tblSubTerritory Tsubtr  with (nolock) on Tsubtr.SubTerritoryId =mas.TSubTerritoryId
	left join tblTerritory Ftr  with (nolock) on Ftr.TerritoryId =mas.FTerritoryId
	left join tblTerritory Ttr  with (nolock) on Ttr.TerritoryId =mas.TTerritoryId
	left join tblArea Far  with (nolock) on Far.AreaId =mas.FAreaId
	left join tblArea Tar  with (nolock) on Tar.AreaId =mas.TAreaId


	left join tblMarket mar  with (nolock) on mar.MarketId =mas.TMarketId

	 where mas.ApprovalStatus is null and mas.MarketType=@Parm
END