CREATE PROCEDURE [dbo].[sp_Save_GenericGroup]
	-- Add the parameters for the stored procedure here
    @id INT,
    @GenericGroupName NVARCHAR(MAX),
    @EntryBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@InactiveDate Datetime = NUll

AS
    BEGIN
	
	if not exists (select GenericGroupName from tblGenericGroup where GenericGroupName=@GenericGroupName )
    begin 

        DECLARE @GenericGroupCode NVARCHAR(MAX)

        SELECT  @GenericGroupCode = 'GENG-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(GenericGroupId) + 10001 )) ) FROM  tblGenericGroup

        INSERT INTO tblGenericGroup
           (
			GenericGroupName
			,GenericGroupCode			
           ,IsActive
           ,EntryBy
           ,EntryDate
		   ,InactiveBy
		   ,InactiveDate        
           )
     VALUES
           (
		    @GenericGroupName,
			@GenericGroupCode,
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