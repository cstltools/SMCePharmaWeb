
CREATE PROCEDURE [dbo].[sp_Get_OfferTypeInfo]
	-- Add the parameters for the stored procedure here
  @id INT

AS
    BEGIN

	SELECT *
	FROM tbl_BonusOnType AS GRP  
	INNER JOIN tblCampaignBonusMap map ON map.BonusTypeId=GRP.BonusTypeId
	WHERE map.CampainTypeId=@id

 END
