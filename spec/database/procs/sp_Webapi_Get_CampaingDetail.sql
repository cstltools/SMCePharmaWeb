
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CampaingDetail]
	-- Add the parameters for the stored procedure here
@campaignMasterid INT,
@productid INT
AS
BEGIN
		
SELECT * FROM dbo.tbl_BonusCampaignNewDetail WHERE CampaignMasterId=@campaignMasterid AND BonusProductId=@productid


END


