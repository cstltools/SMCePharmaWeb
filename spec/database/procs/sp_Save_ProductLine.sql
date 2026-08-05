
create PROCEDURE [dbo].[sp_Save_ProductLine]
	-- Add the parameters for the stored procedure here
    @id INT,
    @LineName  NVARCHAR(MAX),
    @EntryBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@InactiveDate Datetime = NUll

AS
    BEGIN
	
	if not exists (select LineName from tblProductLine where  LineName=@LineName  )
    begin 

        

        INSERT INTO tblProductLine
           (
			LineName
		   	
           ,IsActive
           ,EntryBy
           ,EntryDate
		   ,InactiveBy
		   ,InactiveDate        
           )
     VALUES
           (
		    @LineName,
			 
			@IsActive,
		    @EntryBy,
		    GETDATE(),
			@InactiveBy,
			@InactiveDate
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END