
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_Degree_All]
	-- Add the parameters for the stored procedure here
	 
AS
BEGIN
	

	SELECT DegreeId, case when   IsActive = 1 then DegreeName else  DegreeName+' (Inactive)' end DegreeName FROM tblDoctorDegree with (nolock)  

END



