CREATE PROCEDURE [dbo].[sp_Webapi_Check_DcrProduct]
	-- Add the parameters for the stored procedure here
@prdIdStr NVARCHAR(max),
 
@empid INT
AS
BEGIN
SELECT ISNULL(sum(Qty),0) Qty FROM dbo.tblGroupWisePromoQty WHERE EmpInfoId=@empid AND ProductId in (select * from fnSplit
(@prdIdStr,',')) 

end