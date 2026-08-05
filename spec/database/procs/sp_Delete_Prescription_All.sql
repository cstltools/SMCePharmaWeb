-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_Prescription_All]
	-- Add the parameters for the stored procedure here
    @PrescriptionTypeId INT

AS
    BEGIN

    Delete From tbl_PrescriptionMaster  where PrescriptionId = @PrescriptionTypeId
	
    Delete From tbl_PrescriptionProductDetail  where PrescriptionId = @PrescriptionTypeId

    END

