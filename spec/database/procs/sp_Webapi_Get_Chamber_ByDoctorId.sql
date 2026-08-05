
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE 
sp_Webapi_Get_Chamber_ByDoctorId
	-- Add the parameters for the stored procedure here

	@DoctorId INT

AS
BEGIN
	

	SELECT tblDoctorChemberDetail.ChemberId  ChemberId,name  ChemberName, DoctorId FROM dbo.tblDoctorChemberDetail with (nolock) WHERE    DoctorId = @DoctorId

END


