-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_ContactType_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN

	SELECT * FROM dbo.tbl_ContactType WHERE IsActive=1

END


