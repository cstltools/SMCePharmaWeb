-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_DoctorCategory]
	-- Add the parameters for the stored procedure here
    @CategoryId INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE  dbo.tblDoctorCategory
        SET     
                DeleteBy = @DeleteBy ,


                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   CategoryId = @CategoryId

    END


