-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_StationType_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN

		SELECT * FROM dbo.tblStationType WHERE IsActive = 1

END


