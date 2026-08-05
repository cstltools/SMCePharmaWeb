
 CREATE PROCEDURE [dbo].[sp_Save_DesignationInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @DesigName  NVARCHAR(MAX),
    @EntryBy INT ,
    @IsActive BIT 

AS
    BEGIN
	
		if not exists (select DesigName from tblDesignation where DesigName=@DesigName)
    begin 

        DECLARE @DesignationCode NVARCHAR(MAX)

        SELECT  @DesignationCode = 'DSG - ' + ( CONVERT(NVARCHAR(MAX), ( COUNT(DesignationId) + 10001 )) ) FROM  tblDesignation


        INSERT INTO tblDesignation
           (
			DesigCode
           ,DesigName
           ,EntryBy
           ,EntryDate
           ,IsActive
           )
     VALUES
           (
		   @DesignationCode,
		   @DesigName,
		   @EntryBy,
		   GETDATE(),
		   @IsActive 
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END
