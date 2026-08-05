CREATE PROCEDURE [dbo].[sp_CS_Transport_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT   *	FROM dbo.tbl_Transport   WITH (NOLOCK) WHERE IsActive=1
END
