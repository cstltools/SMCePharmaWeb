
CREATE PROCEDURE [dbo].[sp_Save_CustomerTypeInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @CustomerType NVARCHAR(MAX) ,
    @EntryBy INT ,
    @CustomerCategoryId INT =null,
    @IsActive BIT , 
    @IsCampaign BIT ,
    @IsDefault BIT 


AS
    BEGIN
	
			if not exists (select CustomerType from tblCustomerType where CustomerType=@CustomerType)
    begin 
--		 declare @CountData int
--SELECT @CountData=COUNT(*) FROM dbo.tblCustomerType WHERE IsDefault=1

--print @CountData
-- IF(@CountData=0)
-- BEGIN 

        DECLARE @DepartmentCode NVARCHAR(MAX)

        SELECT  @DepartmentCode = 'CUS-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(CustomerTypeId) + 10001 )) ) FROM  tblCustomerType


        INSERT INTO tblCustomerType
           (
			CustTypeCode
           ,CustomerType
           ,EntryBy
           ,EntryDate
           ,IsActive,IsOrderApproval,IsDefault,  CustomerCategoryId
      
           )
     VALUES
           (
		   @DepartmentCode,
		   @CustomerType,
		   @EntryBy,
		   GETDATE(),
		   @IsActive  ,@IsCampaign ,@IsDefault, @CustomerCategoryId
 
		   )

		SELECT SCOPE_IDENTITY()

		End
  else  Return 0
--End
--  else  Return 0
    END
