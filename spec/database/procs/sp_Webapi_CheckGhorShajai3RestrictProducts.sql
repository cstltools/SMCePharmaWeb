CREATE PROCEDURE [dbo].[sp_Webapi_CheckGhorShajai3RestrictProducts]
	-- Add the parameters for the stored procedure here
	@ProductID INT 

AS
BEGIN
select ProductName from tblGhorShajai3RestrictProducts  where ProductID=@ProductID
end