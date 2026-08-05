-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Delete_Dcr]
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
	
	DELETE FROM dbo.tbl_DCRInfo WHERE DcrId = @id
	DELETE FROM dbo.tbl_DcrDetails WHERE DcrId = @id


END

