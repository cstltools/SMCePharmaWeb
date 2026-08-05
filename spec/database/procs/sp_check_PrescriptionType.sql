
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_check_PrescriptionType]
	-- Add the parameters for the stored procedure here
	  @PrescriptionTypeId INT = 0 ,
    @PrescriptionType NVARCHAR(MAX) 
AS
BEGIN
		 
SELECT * FROM dbo.tbl_PrescriptionType WHERE PrescriptionType=@PrescriptionType AND PrescriptionTypeId NOT IN ( @PrescriptionTypeId)

END


