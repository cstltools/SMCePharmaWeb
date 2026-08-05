create PROCEDURE [dbo].[sp_Webapi_CheckGhorShajai2RestrictProducts]
	-- Add the parameters for the stored procedure here
	@ProductID INT 

AS
BEGIN
select ProductName from tblGhorShajai2RestrictProducts  where ProductID=@ProductID
end