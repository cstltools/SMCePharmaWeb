
CREATE PROCEDURE [dbo].[sp_UD_DepartmentInfo]
	-- Add the parameters for the stored procedure here
    @id INT,
    @DepartmentName NVARCHAR(MAX) ,
    @UpdateBy INT ,
    @IsActive BIT

AS
    BEGIN


		UPDATE tblDepartment 
		SET DeptName = @DepartmentName,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE DeptId =  @id
       

    END
