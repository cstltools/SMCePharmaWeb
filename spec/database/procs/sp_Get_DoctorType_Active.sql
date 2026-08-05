-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorType_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN

		SELECT * FROM dbo.tblDoctorType WHERE IsActive = 1

END


