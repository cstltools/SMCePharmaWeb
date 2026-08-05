

 CREATE PROCEDURE [dbo].[sp_GET_CustomerType_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select  IsOrderApproval IsCampaign, ISNULL(CustomerCategoryId,0) CustomerCategoryId, * from tblCustomerType where CustomerTypeId = @id
      
    END


