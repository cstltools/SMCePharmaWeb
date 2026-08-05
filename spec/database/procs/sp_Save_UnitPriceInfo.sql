
CREATE PROCEDURE [dbo].[sp_Save_UnitPriceInfo]
	-- Add the parameters for the stored procedure here
    @id INT,
	@CompanyId INT,
    @ProductName  NVARCHAR(MAX),
	@ProductCode  NVARCHAR(MAX),
	@ProductId INT,
	@PackSize  NVARCHAR(MAX),
	@CostPrice decimal(18,2),
	@UnitPrice decimal(18,2),
	@MRPPrice decimal(18,2),
	@VATPercentage decimal(18,2),
	@VATAmountPerUnit decimal(18,2),
	@IsActive BIT,
	@ActiveDate datetime,
    @EntryBy INT 

AS
    BEGIN
	
	if not exists (select ProductName from tblUnitPrice where  ProductName=@ProductName and IsActive=1)
    begin 

        DECLARE @ActionStatus NVARCHAR(MAX)

        SELECT  @ActionStatus=ActionValue FROM  tblAction where ActionValue='Posted'

        INSERT INTO tblUnitPrice
           (
			CompanyId
			,ProductName
			,ProductCode			
           ,ProductId
		   ,PackSize
		   ,CostPrice
		   ,UnitPrice
		   ,MRPPrice
		   ,VATPercentage
		   ,VATAmountPerUnit
		   ,IsActive
		   ,ActiveDate 
           ,EntryBy
           ,EntryDate 	
		   ,ActionStatus          
           )
     VALUES
           (
		    @CompanyId,
			@ProductName,
			@ProductCode,
			@ProductId,
			@PackSize,
			@CostPrice,
			@UnitPrice,
			@MRPPrice,
			@VATPercentage,
			@VATAmountPerUnit,
			@IsActive,
			@ActiveDate,
		    @EntryBy,
		    GETDATE(),
			@ActionStatus
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END




	