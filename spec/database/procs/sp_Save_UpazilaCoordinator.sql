

CREATE PROCEDURE [dbo].[sp_Save_UpazilaCoordinator]
	-- Add the parameters for the stored procedure here
    @id INT,
	@DivisionId INT ,
	@DistrictId INT ,
	@ThanaId    INT,
    @EmpInfoId  INT ,
    @EntryBy    INT ,
    @IsActive BIT
AS
    BEGIN
	
	if not exists (select EmpInfoId from tblUpazilaCoordinator where EmpInfoId=@EmpInfoId)
    begin 

        DECLARE @CoordinatoCode NVARCHAR(MAX)

        SELECT  @CoordinatoCode = 'UPC-' + ( CONVERT(NVARCHAR(MAX), ( COUNT(UpCoordinatorId) + 10001 )) ) FROM  tblUpazilaCoordinator

        INSERT INTO tblUpazilaCoordinator
           (
			UpCoordinatorCode
		   ,DivisionId
		   ,DistrictId	
		   ,ThanaId
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
			@ThanaId,
			@EmpInfoId,
			@IsActive,
		    @EntryBy,
		    GETDATE()
		   )

		SELECT SCOPE_IDENTITY()
End
  else  Return 0
    END

