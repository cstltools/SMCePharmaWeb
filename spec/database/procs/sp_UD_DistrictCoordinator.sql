

CREATE PROCEDURE [dbo].[sp_UD_DistrictCoordinator]
	-- Add the parameters for the stored procedure here
    @id INT,
	@DivisionId INT ,
	@DistrictId INT ,
    @EmpInfoId INT ,
    @UpdateBy INT ,
    @IsActive BIT

AS
    BEGIN


		UPDATE tblDistrictCoordinator 
		SET DivisionId = @DivisionId,DistrictId=@DistrictId,EmpInfoId=@EmpInfoId ,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE DistCoordinatorId =  @id
       

    END

