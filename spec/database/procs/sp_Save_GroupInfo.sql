
CREATE PROCEDURE [dbo].[sp_Save_GroupInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @NationalId INT = 0 ,
    @GroupName NVARCHAR(MAX),
    @CodeStr NVARCHAR(MAX),
    @EntryBy INT ,
    @IsActive BIT 

AS
    BEGIN
	
	IF NOT EXISTS (select GroupName from tbl_Group where GroupName = @GroupName)
    BEGIN 

        DECLARE @GroupCode NVARCHAR(MAX)

        SELECT @GroupCode = 'GRP - ' + ( CONVERT(NVARCHAR(MAX), ( COUNT(GroupId) + 10001 )) ) FROM  tbl_Group


        INSERT INTO tbl_Group
           (GroupCode,CodeStr,
		    GroupName
           ,IsActive
           ,EntryBy
           ,EntryDate,NationalId
           )
     VALUES
           (@CodeStr,@GroupCode,
		   @GroupName,
		   @IsActive,
		   @EntryBy,
		   GETDATE(),@NationalId)

		SELECT SCOPE_IDENTITY()

	END
		ELSE  	
		Return 0
    END
