-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_DoctorDegree]
	-- Add the parameters for the stored procedure here
    @DegreeId INT = 0 ,
    @DeleteBy NVARCHAR(50)

AS
    BEGIN

        UPDATE  dbo.tblDoctorDegree
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   DegreeId = @DegreeId

    END


