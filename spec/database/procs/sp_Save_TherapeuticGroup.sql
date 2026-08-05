
CREATE PROCEDURE [dbo].[sp_Save_TherapeuticGroup]
	-- Add the parameters for the stored procedure here
    @id INT,
    @TherapeuticGroupName  NVARCHAR(MAX),
    @EntryBy INT ,
    @IsActive BIT,
	@InactiveBy INT = NULL,
	@InactiveDate Datetime = NUll

AS
    BEGIN
	
	if not exists (select TherapeuticGroupName from tblTherapeuticGroup where TherapeuticGroupName=@TherapeuticGroupName  )
    begin 

        DECLARE @TherapeuticGroupCode NVARCHAR(MAX)

        SELECT  @TherapeuticGroupCode = 'TRPG-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(TherapeuticGroupId) + 10001 )) ) FROM  tblTherapeuticGroup

        INSERT INTO tblTherapeuticGroup
           (
			TherapeuticGroupName
		   ,TherapeuticGroupCode			
           ,IsActive
           ,EntryBy
           ,EntryDate
		   ,InactiveBy
		   ,InactiveDate        
           )
     VALUES
           (
		    @TherapeuticGroupName,
			@TherapeuticGroupCode,
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