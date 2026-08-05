

 CREATE PROCEDURE [dbo].[sp_GET_GetOrderDtlCamCheckId]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	

select * from tblOrderDetail c where OrderId=@id and CampaignName  in ('Bonus Campaign | Special Rate [Triforce 500]-Feb-24', 
'Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24','Bonus Campaign | Special Rate [Triforce 1g IM]-Feb-24','Bonus Campaign | Special Rate [Triforce 500]-Feb-24' )



      
    END


