CREATE PROCEDURE [dbo].[sp_CS_Designation_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		 
		SELECT   *	 	FROM dbo.tblDesignation WITH (NOLOCK)   WHERE IsActive=1
END
