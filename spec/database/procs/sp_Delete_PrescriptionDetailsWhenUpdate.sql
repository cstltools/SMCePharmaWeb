
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_PrescriptionDetailsWhenUpdate]
	-- Add the parameters for the stored procedure here
    @PrescriptionTypeId INT 

AS
    BEGIN

 Delete from tbl_PrescriptionProductDetail where PrescriptionId = @PrescriptionTypeId

    END


