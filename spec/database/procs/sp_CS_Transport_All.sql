CREATE PROCEDURE [dbo].[sp_CS_Transport_All]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT   CASE WHEN IsActive=1 THEN   TransportName+' (Active)' ELSE   TransportName+' (Inactive)' END  TransportName,  *	FROM dbo.tbl_Transport   WITH (NOLOCK) 
END
