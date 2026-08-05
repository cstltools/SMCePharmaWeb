-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ChamberType_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN

		SELECT * FROM dbo.tblDoctorChamber WHERE IsActive = 1

END


