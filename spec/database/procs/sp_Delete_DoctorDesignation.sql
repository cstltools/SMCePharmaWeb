-- =============================================
-- Author:		<Author,,tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_DoctorDesignation]
	-- Add the parameters for the stored procedure here
    @DesignationId INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE  dbo.tblDoctorDesignation
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   DesignationId = @DesignationId

    END


