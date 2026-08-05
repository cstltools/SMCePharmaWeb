create PROCEDURE [dbo].[sp_CS_National_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT NationalId,NationalCode+' : '+ NationalName NationalName FROM dbo.tbl_National   with(nolock) WHERE IsActive = 1   
END
