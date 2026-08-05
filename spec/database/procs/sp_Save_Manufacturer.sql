CREATE PROCEDURE [dbo].[sp_Save_Manufacturer]
	-- Add the parameters for the stored procedure here
    @id INT,
    @ManufacName  NVARCHAR(MAX),
	@ManufacAddress  NVARCHAR(MAX),
    @EntryBy INT ,
    @IsActive BIT,
	@InactiveBy INT,
	@ActiveInactiveDate datetime

AS
    BEGIN
	
	if not exists (select ManufacName from tblManufacturer where ManufacName=@ManufacName)
    begin 

        DECLARE @ManufacCode NVARCHAR(MAX)

        SELECT  @ManufacCode = 'MAFC-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(ManufacId) + 10001 )) ) FROM  tblManufacturer

        INSERT INTO tblManufacturer
           (
			ManufacName
			,ManufacAddress
			,ManufacCode			
           ,IsActive
           ,EntryBy
           ,EntryDate 
		   ,InactiveBy
		   ,ActiveInactiveDate
		          
           )
     VALUES
           (
		    @ManufacName,
			@ManufacAddress,
			@ManufacCode,
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