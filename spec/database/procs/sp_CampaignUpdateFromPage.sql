


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_CampaignUpdateFromPage]
	-- Add the parameters for the stored procedure here
	@Ids as nvarchar(max)
AS
BEGIN
		 
	truncate table tblCustMasterCampNew


INSERT INTO tblCustMasterCampNew (CustomerMasterId, CustomerCode, CampaignMasterId, custtypeid,EntryDate)
SELECT 
vv.CustomerId,
vv.CustomerCode,
vv.CampMasId,
23, getdate()
FROM dbo.GetCampaignCustomer(23) vv


INSERT INTO tblCustMasterCampNew (CustomerMasterId, CustomerCode, CampaignMasterId, custtypeid,EntryDate)
SELECT 
vv.CustomerId,
vv.CustomerCode,
vv.CampMasId,
16, getdate()
FROM dbo.GetCampaignCustomer(16) vv



INSERT INTO tblCustMasterCampNew (CustomerMasterId, CustomerCode, CampaignMasterId, custtypeid,EntryDate)
SELECT 
vv.CustomerId,
vv.CustomerCode,
vv.CampMasId,
1, getdate()
FROM dbo.GetCampaignCustomer(1) vv





END




