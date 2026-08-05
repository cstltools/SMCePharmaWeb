
CREATE PROCEDURE [dbo].[sp_Webapi_GetCampaignData]
	-- Add the parameters for the stored procedure here

@OrderProductId INT NULL ,
@param NVARCHAR(MAX)=''
AS
BEGIN
	
	DECLARE @Q NVARCHAR(MAX)=''

	SET @Q='

	SELECT * FROM dbo.tbl_BonusCampaignNewMaster
	LEFT JOIN dbo.tbl_BonusCampaignNewDetail ON tbl_BonusCampaignNewDetail.CampaignMasterId = tbl_BonusCampaignNewMaster.CampgainMasterId
	WHERE  tbl_BonusCampaignNewDetail.BonusProductId='+CONVERT(NVARCHAR(MAX),@OrderProductId)+' AND (getDate() between FromDate and Todate)
	'+ @param

	EXEC sp_executesql @Q 

END

