CREATE PROCEDURE [dbo].[sp_webapi_GetOrderMasterById]
	-- Add the parameters for the stored procedure here
@id INT=null 
AS
BEGIN
			SELECT cst.CustomerCode,cst.CustomerName,cst.Address, mas.TotalNetPayable TotalAmount, mas.GrossValue  TotalTP,mas.TotalVAT,  *  FROM dbo.tblOrder mas   with (nolock)
			inner join tblCustMaster cst   with (nolock) on mas.CustomerMasterId=cst.CustomerMasterId

		 
			 

WHERE mas.OrderId=@id
END
