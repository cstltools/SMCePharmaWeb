
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_DoctorDegree]
	-- Add the parameters for the stored procedure here
	  @DegreeId INT = 0 ,
	@DoctorTypeId int=null,

    @DegreeName NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblDoctorDegree WHERE DegreeName=@DegreeName AND DoctorTypeId=@DoctorTypeId and   DegreeId NOT IN ( @DegreeId)

END


