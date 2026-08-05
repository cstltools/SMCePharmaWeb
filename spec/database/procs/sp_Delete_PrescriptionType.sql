
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_PrescriptionType]
	-- Add the parameters for the stored procedure here
    @PrescriptionTypeId INT 
   
AS
    BEGIN

	Delete from tbl_PrescriptionType where PrescriptionTypeId = @PrescriptionTypeId

    --    UPDATE [dbo].[tblPrescriptionType]
    --    SET     
    --            DeleteBy = @DeleteBy ,
    --            DeleteDate = GETDATE() ,
				--IsDelate = 1                     
    --    WHERE   PrescriptionTypeId = @PrescriptionTypeId 

    END

