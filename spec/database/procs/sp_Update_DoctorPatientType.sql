-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Update_DoctorPatientType]
	-- Add the parameters for the stored procedure here
    @PatientTypeId  INT = 0 ,
    @PatientType   NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN

        UPDATE  [dbo].[tblDoctorPatientType]
        SET     PatientType = @PatientType ,
                UpdateBy = @UpdateBy ,
                UpdateDate = GETDATE(),
                IsActive = @isActive ,      
                Activedate = @Activedate
        WHERE   PatientTypeId = @PatientTypeId 

    END


