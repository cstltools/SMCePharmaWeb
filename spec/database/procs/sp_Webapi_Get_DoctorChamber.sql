-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorChamber]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		


		SELECT ChamberId ChamberTypeId,ChamberName ChamberTypeName
			    FROM dbo.tblDoctorChamber WHERE IsActive = 1


END

