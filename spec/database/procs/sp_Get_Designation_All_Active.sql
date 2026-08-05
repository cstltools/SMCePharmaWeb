
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_Designation_All_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	SELECT * FROM tblDoctorDesignation WHERE IsActive = 1

END


