
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_DoctorDegreeDetail]
	-- Add the parameters for the stored procedure here
	  @DegreeId INT = 0  
AS
BEGIN
		 
		SELECT * FROM dbo.tblDoctorDegreeDetail WHERE    DegId= @DegreeId

END


