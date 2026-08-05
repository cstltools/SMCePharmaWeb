
CREATE PROCEDURE [dbo].[sp_Save_RouterMaster]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @RouterName NVARCHAR(MAX) ,
    @EntryBy INT 

AS
    BEGIN
	
	if not exists (select RouterName from RouterMaster where RouterName=@RouterName)
    begin 

        DECLARE @DepartmentCode NVARCHAR(MAX)

        SELECT  @DepartmentCode = 'ROTE-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(RouterMasterId) + 10001 )) ) FROM  RouterMaster


        INSERT INTO RouterMaster
           (
			RouterName
			,RouterCode
           ,IsActive
           ,EntryBy
           ,EntryDate
         
           )
     VALUES
           (
		    @RouterName,
			@DepartmentCode,
			1,
		   @EntryBy,
		   GETDATE()
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
