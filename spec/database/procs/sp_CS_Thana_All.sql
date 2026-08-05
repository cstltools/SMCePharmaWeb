create PROCEDURE [dbo].[sp_CS_Thana_All]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT  ThanaId, ThanaName   FROM dbo.tbl_Thana   with (nolock)
		order by ThanaName asc
END
