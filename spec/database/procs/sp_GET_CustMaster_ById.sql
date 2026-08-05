

 CREATE PROCEDURE [dbo].[sp_GET_CustMaster_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 SELECT (SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Customer')AS ImagePreName ,(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='TradeLicense')AS TradeLicensePreName , mas.MarketId,subTr.SubTerritoryId, Tr.TerritoryId, Ar.AreaId, rg.RegionId,gr.GroupId, dtl.ProductLineID, mas.ThanaId, dis.DistrictId,dis.DivisionId,  mas.* from tblCustMaster mas with (nolock)
	 
	 left join  tblCustProductLine dtl on mas.CustomerMasterId=dtl.CustomerMasterId
	 left join  tblMarket mr on mas.MarketId=mr.MarketId
	 left join  tblSubTerritory subTr on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr on gr.GroupId=rg.GroupId
	 left join  tbl_Thana  th on th.ThanaId=mas.ThanaId
	 left join  tbl_District  dis on th.district_id=dis.DistrictId








	  where mas.CustomerMasterId = @id
      
    END


