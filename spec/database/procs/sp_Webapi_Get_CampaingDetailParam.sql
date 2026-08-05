

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CampaingDetailParam]
	-- Add the parameters for the stored procedure here
@campaignMasterid INT,
@param NVARCHAR(MAX)
AS
BEGIN
	
	DECLARE @q NVARCHAR(MAX)='
SELECT * FROM dbo.tbl_BonusCampaignNewDetail WHERE CampaignMasterId='+CONVERT(NVARCHAR(MAX),@campaignMasterid)+' '+@param

	 EXEC sys.sp_executesql @q



END



