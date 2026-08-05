-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 create PROCEDURE [dbo].[sp_Update_PromoMIOTagMaster]
	-- Add the parameters for the stored procedure here
	@MIOTagId INT,
	@PromoGroupId INT,
     
    
    
	 
	@EntryBy nvarchar(50)=NULL 


   
AS
    BEGIN

       UPDATE [dbo].tblPromoMIOTagMaster set
     PromoGroupId = @PromoGroupId,
      
      
	  UpdateBy=@EntryBy,
	  UpdateDate=getdate()                     
        WHERE    MIOTagId = @MIOTagId

		Delete From dbo.tblPromoMIOTagDetail where  MIOTagMasterId = @MIOTagId
	 

    END

