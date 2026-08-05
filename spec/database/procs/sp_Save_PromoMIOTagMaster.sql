-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_PromoMIOTagMaster]
	-- Add the parameters for the stored procedure here
	@MIOTagId INT,
	@PromoGroupId INT,
     
    
    
	 
	@EntryBy nvarchar(50)=NULL 

AS
    BEGIN
	
      INSERT INTO dbo.tblPromoMIOTagMaster
                                (
                                    PromoGroupId,
                                    EntryBy,
                                    EntryDate
                                )
                                VALUES
                                (@PromoGroupId,
                                    @EntryBy,
                                    GETDATE())

SELECT SCOPE_IDENTITY()

END

