-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorDegree] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT DegreeId,DegreeName, DoctorTypeId FROM dbo.tblDoctorDegree WHERE IsActive = 1
		 



END

