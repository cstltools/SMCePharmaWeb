

CREATE PROCEDURE [dbo].[sp_UD_CustomerTypeInfo]
	-- Add the parameters for the stored procedure here
     @id INT = 0 ,
    @CustomerType NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT, 
    @IsCampaign BIT 
	,
    @IsDefault BIT ,
	    @CustomerCategoryId INT =null 
AS
    BEGIN


		UPDATE tblCustomerType 
		SET   IsDefault=@IsDefault, CustomerType = @CustomerType,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive  ,IsOrderApproval = @IsCampaign,  CustomerCategoryId =@CustomerCategoryId
      
		WHERE CustomerTypeId =  @id
       

    END

