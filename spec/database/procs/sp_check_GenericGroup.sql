CREATE PROCEDURE [dbo].[sp_check_GenericGroup]
	-- Add the parameters for the stored procedure here
	@id INT ,
    @GenericGroupName     NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblGenericGroup WHERE GenericGroupName=@GenericGroupName AND GenericGroupId NOT IN ( @id)
END