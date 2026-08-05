-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorInistitutionDetail]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@InstitutionId INT

AS
BEGIN
	
	
	INSERT INTO tblDoctorInstitutionDetail
           (DoctorId
           ,InstitutionId)
     VALUES
           (@DoctorId
           ,@InstitutionId)

END

