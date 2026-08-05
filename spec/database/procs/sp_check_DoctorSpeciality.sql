
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_DoctorSpeciality]
	-- Add the parameters for the stored procedure here
	  @SpecialityId INT = 0 ,
    @SpecialityName NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblDoctorSpeciality WHERE SpecialityName=@SpecialityName AND     SpecialityId NOT IN ( @SpecialityId)

END


