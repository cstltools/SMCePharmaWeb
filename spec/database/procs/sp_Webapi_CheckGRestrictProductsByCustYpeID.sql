CREATE PROCEDURE [dbo].[sp_Webapi_CheckGRestrictProductsByCustYpeID]
	-- Add the parameters for the stored procedure here
	@ProductID INT ,
	@custtypeid INT 

AS
BEGIN
select ProductName from tblRestrictProducts  where ProductID=@ProductID and CustYpeID=@custtypeid
end

 