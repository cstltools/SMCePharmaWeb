-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Update_DoctorSpeciality]
	-- Add the parameters for the stored procedure here
    @SpecialityId INT = 0 ,
    @SpecialityName  NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN

        UPDATE [dbo].[tblDoctorSpeciality] 
        SET     SpecialityName = @SpecialityName,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE(),
                IsActive = @isActive,      
                Activedate = @Activedate
        WHERE   SpecialityId = @SpecialityId 

    END

