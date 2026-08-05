-- =============================================
-- Author:		<Author,,tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_DoctorpatientType]
	-- Add the parameters for the stored procedure here
    @PatientTypeId INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE  [dbo].[tblDoctorPatientType] 
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   PatientTypeId = @PatientTypeId 

    END

