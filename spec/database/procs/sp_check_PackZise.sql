CREATE PROCEDURE [dbo].[sp_check_PackZise]
	-- Add the parameters for the stored procedure here
	@id  INT ,
    @PackSizeName   NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblPackSize WHERE PackSizeName=@PackSizeName AND PackSizeId NOT IN ( @id)

END
