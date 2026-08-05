

CREATE PROCEDURE [dbo].[sp_Save_DistrictCoordinator]
	-- Add the parameters for the stored procedure here
    @id INT,
	@DivisionId INT ,
	@DistrictId INT ,
    @EmpInfoId INT ,
    @EntryBy INT ,
    @IsActive BIT
AS
    BEGIN
	
	if not exists (select EmpInfoId from tblDistrictCoordinator where EmpInfoId=@EmpInfoId)
    begin 

        DECLARE @CoordinatoCode NVARCHAR(MAX)

        SELECT  @CoordinatoCode = 'DSTC-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(DistCoordinatorId) + 10001 )) ) FROM  tblDistrictCoordinator

        INSERT INTO tblDistrictCoordinator
           (
			DistCoordinatorCode
		   ,DivisionId
		   ,DistrictId	
		   ,EmpInfoId		
           ,IsActive
           ,EntryBy
           ,EntryDate        
           )
     VALUES
           (
		    @CoordinatoCode,
			@DivisionId,
			@DistrictId,
			@EmpInfoId,
			@IsActive,
		    @EntryBy,
		    GETDATE()
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END

