
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetChamber_ByDoctorId]
	-- Add the parameters for the stored procedure here

	@DoctorId INT

AS
BEGIN
	

	SELECT tblDoctorChemberDetail.ChemberId , name   Chember  FROM dbo.tblDoctorChemberDetail with (nolock) WHERE    DoctorId = @DoctorId

END


