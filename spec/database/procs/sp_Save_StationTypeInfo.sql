
CREATE PROCEDURE [dbo].[sp_Save_StationTypeInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @StationTypeName   NVARCHAR(MAX) ,
    @EntryBy INT ,
    @IsActive BIT ,
	  @StartTime TIME ,
    @EndTime TIME 
   

AS
    BEGIN
	
		if not exists (select StationTypeName from tblStationType where StationTypeName=@StationTypeName)
begin 


        DECLARE @DepartmentCode NVARCHAR(MAX)

        SELECT  @DepartmentCode = 'STA - ' + ( CONVERT(NVARCHAR(MAX), ( COUNT(StationTypeId) + 10001 )) ) FROM  tblStationType


        INSERT INTO tblStationType
           (
			StationCode
		   ,StationTypeName          
           ,EntryBy
           ,EntryDate
           ,IsActive,StartTime,EndTime
           )
     VALUES
           (
		   @DepartmentCode,
		   @StationTypeName,
		   @EntryBy,
		   GETDATE(),
		   @IsActive ,@StartTime,@EndTime
		   )

		SELECT SCOPE_IDENTITY()
End
else  Return 0
    END
