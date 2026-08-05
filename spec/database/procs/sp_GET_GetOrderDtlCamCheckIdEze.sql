

 create PROCEDURE [dbo].[sp_GET_GetOrderDtlCamCheckIdEze]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	

select * from tblOrderDetail c where OrderId=@id and CampaignName  in ('Ezevent Flat Rate Campaign | Dec-25' )



      
    END


