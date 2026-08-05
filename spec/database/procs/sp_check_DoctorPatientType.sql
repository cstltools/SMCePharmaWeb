
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_DoctorPatientType]
	-- Add the parameters for the stored procedure here
	  @PatientTypeId INT = 0 ,
    @PatientType NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.[tblDoctorPatientType] WHERE PatientType=@PatientType AND    PatientTypeId NOT IN ( @PatientTypeId)

END


