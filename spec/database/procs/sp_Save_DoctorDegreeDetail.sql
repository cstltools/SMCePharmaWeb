-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorDegreeDetail]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@DegId INT

AS
BEGIN
	
	INSERT INTO [dbo].[tblDoctorDegreeDetail]
           (
           DoctorId
           ,DegId)
     VALUES
           (
            @DoctorId
           ,@DegId)
END

