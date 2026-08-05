

Create PROCEDURE [dbo].[sp_UD_UpazilaCoordinator]
	-- Add the parameters for the stored procedure here
    @id INT,
	@DivisionId INT ,
	@DistrictId INT ,
	@ThanaId    INT,
    @EmpInfoId INT ,
    @UpdateBy INT ,
    @IsActive BIT

AS
    BEGIN


		UPDATE tblUpazilaCoordinator 
		SET DivisionId = @DivisionId,DistrictId=@DistrictId,EmpInfoId=@EmpInfoId,ThanaId=@ThanaId,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE UpCoordinatorId =  @id
       

    END

