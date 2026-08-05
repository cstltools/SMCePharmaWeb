CREATE PROCEDURE [dbo].[sp_CS_Shift_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		 
		SELECT   *	 	FROM dbo.tbl_Shift WITH (NOLOCK)   WHERE IsActive=1
END
