-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_OPAPI_GetCampaignMaster]
	-- Add the parameters for the stored procedure here
	@CustomerID int
AS
BEGIN
	

	DECLARE @TypeId INT

	SELECT @TypeId=CustomerTypeId FROM dbo.tblCustMaster WHERE CustomerMasterId=@CustomerID

	IF(EXISTS(SELECT * FROM GetCampaignCustomer(@TypeId)))

BEGIN
    SELECT 
	   A.CampgainMasterId,
       A.CampaignCode,
       A.ProductLineID,
       A.EntryBy,
       A.EntryDate,
       A.CompanyId,
       A.CampaignName,
       A.CampaignDesc,
       A.FromDate,
       A.Todate,
       A.CampainTypeId,
       A.IsActive,
       A.CustomerTypeId,
       A.Amount,
       A.MaxAmount,
       A.ProductQty,
       A.IsTradePolicy,
       A.BonusProductId,
       A.UpdateBy,
       A.UpdateDate,
	   B.CodeName
	   FROM dbo.tbl_BonusCampaignNewMaster A
	   LEFT JOIN dbo.tbl_CampaignType B ON B.CampainTypeId = A.CampainTypeId
	   WHERE A.IsActive = 1
	   and GETDATE() between FromDate and Todate  
END

	


END
