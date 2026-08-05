-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_DoctorCategory] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		select * from tblDoctorCategory  with (nolock) where IsActive=1


END

