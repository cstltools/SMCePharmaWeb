-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Division_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN

		SELECT * FROM dbo.tbl_Division WHERE IsActive = 1

END


