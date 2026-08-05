-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_DoctorSpecailDay]
	-- Add the parameters for the stored procedure here
    @SpecialDayId  INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE [dbo].[tblDoctorSpecialDay] 
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   SpecialDayId = @SpecialDayId 

    END


