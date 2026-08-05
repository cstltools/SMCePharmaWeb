
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_Degree_All_ActiveByDoctorTypeId]
	-- Add the parameters for the stored procedure here
	@id int 
AS
BEGIN
	

	SELECT * FROM tblDoctorDegree WHERE IsActive = 1 and DoctorTypeId=@id

END



