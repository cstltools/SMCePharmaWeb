-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_TPCustomerDetail]
	-- Add the parameters for the stored procedure here
@CustomerMasterId INT,
@pk INT 
AS
BEGIN

 

		INSERT INTO dbo.tblTPCustomerDetail
		        ( TourPlanId, CustomerMasterId)
		VALUES  (
				@pk,@CustomerMasterId
		          )


END    




 








  
