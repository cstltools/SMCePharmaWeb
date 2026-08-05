-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_DoctorChamber]
	-- Add the parameters for the stored procedure here
    @ChamberId INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE  dbo.tblDoctorChamber
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   ChamberId = @ChamberId

    END

