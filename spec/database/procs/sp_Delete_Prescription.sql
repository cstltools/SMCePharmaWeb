-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_Prescription]
	-- Add the parameters for the stored procedure here
    @PrescriptionTypeId INT = 0,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE [dbo].[tblPrescriptionType]
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   PrescriptionTypeId = @PrescriptionTypeId 

    END

