-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_DoctorSpeciality]
	-- Add the parameters for the stored procedure here
    @SpecialityId   INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE  [dbo].[tblDoctorSpeciality]
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   SpecialityId = @SpecialityId  
    END


