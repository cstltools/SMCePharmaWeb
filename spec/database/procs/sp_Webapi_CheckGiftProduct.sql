CREATE
 PROCEDURE [dbo].[sp_Webapi_CheckGiftProduct]
	-- Add the parameters for the stored procedure here
    
    @ProID INT = NULL 
	
AS
    BEGIN
 
 select    * from tblProduct where ProductGroupId=3 and ProductId=@ProID
    END

