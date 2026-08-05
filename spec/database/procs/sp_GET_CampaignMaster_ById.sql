
 CREATE PROCEDURE [dbo].[sp_GET_CampaignMaster_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	declare @CampgainMasterMapId int=0
	declare @CustomerTypeIdNew nvarchar(max)=''
	select @CampgainMasterMapId=CampgainMasterMapId from tbl_BonusCampaignDetailsCustType  where  CampgainMasterId = @id

SELECT @CustomerTypeIdNew= STUFF((
    SELECT ',' + CAST(CustomerTypeId AS VARCHAR)
    FROM tbl_BonusCampaignDetailsCustType
    WHERE CampgainMasterMapId = @CampgainMasterMapId
    FOR XML PATH('')
), 1, 1, '') 
	
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate,
	 Select @CustomerTypeIdNew AS CustomerTypeIdNew,  * from tbl_BonusCampaignNewMaster  Dm
	 
	 where CampgainMasterId = @id
      
    END

	 