-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_BonusCampaignCustomerDetail]
	-- Add the parameters for the stored procedure here
	 

@CampaignMasterId  INT,
@CustomerMasterId  INT 
AS
    BEGIN
	
    INSERT INTO [dbo].tbl_BonusCampaignCustomerDetail
           ([CampaignMasterId]
           ,CustomerMasterId
          )
     VALUES
           (@CampaignMasterId 
           ,@CustomerMasterId 
            )

 

END

