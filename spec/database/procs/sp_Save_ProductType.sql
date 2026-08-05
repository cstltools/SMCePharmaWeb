
CREATE PROCEDURE [dbo].[sp_Save_ProductType]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ProductTypeName  NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@ActiveInactiveDate Datetime = NUll

	

AS
    BEGIN
	
	if not exists (select ProductTypeName from tblProductType where ProductTypeName=@ProductTypeName )
    begin 

        DECLARE @ProductTypeCode NVARCHAR(MAX)

        SELECT  @ProductTypeCode = 'PROT-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(ProductTypeId) + 10001 )) ) FROM  tblProductType

        INSERT INTO tblProductType
           (
			ProductTypeName
			,ProductTypeCode			
           ,IsActive
           ,EntryBy
           ,EntryDate
		   ,InactiveBy
		   ,ActiveInactiveDate     
           )
     VALUES
           (
		    @ProductTypeName,
			@ProductTypeCode,
			@IsActive,
		    @EntryBy,
		    GETDATE(),
			@InactiveBy,
			@ActiveInactiveDate
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END