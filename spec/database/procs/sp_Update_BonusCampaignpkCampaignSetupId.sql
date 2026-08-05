
CREATE PROCEDURE [dbo].[sp_Update_BonusCampaignpkCampaignSetupId]
	-- Add the parameters for the stored procedure here
	@CampaignMasterId INT ,
	@CampgainMasterMapId INT  ,
	@CustomerTypeId int


   
AS
    BEGIN
	declare @CampaignCode_dtl nvarchar(max)
	select @CampaignCode_dtl=CampaignCode from  [dbo].[tbl_BonusCampaignNewMaster]        
        WHERE    CampgainMasterId = @CampaignMasterId 


		INSERT INTO [dbo].[tbl_BonusCampaignDetailsCustType]
           ([CampgainMasterId]
           ,[CampgainMasterMapId]
           ,[CampaignCode_dtl], CustomerTypeId)
     VALUES
           (@CampaignMasterId 
           ,@CampgainMasterMapId
           ,@CampaignCode_dtl, @CustomerTypeId)

    END
