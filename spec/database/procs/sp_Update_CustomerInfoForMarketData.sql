-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_CustomerInfoForMarketData]
	-- Add the parameters for the stored procedure here
    @MasterId INT 
AS
    BEGIN
	 DECLARE @StationTypeId int,@NSMStationTypeId int , @DZSMStationTypeId int
        select  @StationTypeId= ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@MasterId and UserRoleID=1

		   select @NSMStationTypeId=  ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@MasterId and UserRoleID=2

		   	   select @DZSMStationTypeId=  ISNULL(StationTypeId,null) from tblMarketStationDetail where MarketId=@MasterId and UserRoleID=3



			    DECLARE @RouteInformationMasterId int ,@DCId int ,  @GroupId INT,@RegionId INT,@AreaId INT,@TerritoryId INT,@SubTerritoryId INT, @divId int ,@disId int ,@thanaId int 
		select @divId=div.DivisionId,@disId=dis.DistrictId,  @thanaId=mr.ThanaId, @SubTerritoryId=sr.SubTerritoryId,@TerritoryId=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId from tblmarket mr with (nolock)
		inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
		inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
		inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
		inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
		left join tbl_Thana tha  with (nolock) on mr.ThanaId=tha.ThanaId
		left join tbl_District dis  with (nolock) on dis.DistrictId=tha.district_id
	left join tbl_Division div  with (nolock) on dis.DivisionId=div.DivisionId
		  where  MarketId=@MasterId


		  UPDATE dbo.tblCustMaster SET ThanaId=@thanaId, DistrictId=@disId, DivisionId=@divId, StationTypeId=@StationTypeId, NSMStationTypeId=@NSMStationTypeId, DZSMStationTypeId=@DZSMStationTypeId
		   where  MarketId=@MasterId

    END

