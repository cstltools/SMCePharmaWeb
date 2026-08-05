CREATE PROCEDURE [dbo].[sp_Get_DoctorSetupData_ByDoctorId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

        SELECT  DoctorId ,
                DoctorCode ,
                DoctorName ,
                DesignationId ,
                DegreeId ,
                Gender ,
                Speciality ,
                ProgramType ,
                Remarks ,
                IsActive ,
                Activedate ,
                EntryBy ,
                EntryDate ,
                UpdateBy ,
                UpdateDate ,
                InactiveDate ,
                InactiveBy ,
                IsDelate ,
                DeleteBy ,
                DeleteDate ,
                DivisionId ,
                DistrictId ,
                ThanaId ,
                IsFromApp FROM dbo.tblDoctorMaster
				WHERE DoctorId = @id


    END
