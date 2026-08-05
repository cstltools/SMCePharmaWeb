-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Delete_DoctorTourPlan]
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
		
		DELETE FROM dbo.tbl_DoctorTourPlanDetail WHERE DocTPDetailsId = @id


END

