CREATE PROCEDURE [dbo].[sp_webapi_GetAllSampleProducts] -- sp_webapi_GetAllSampleProducts 151
	-- Add the parameters for the stored procedure here
	@empId int
AS
BEGIN

SELECT  C.IsActive, c.ProductId,
		C.ProductCode,
		C.ProductName,
		C.Description,
		0 AS  PackSize,
		0 as UnitPrice,
		0 AS  VATPercentage,
		 0 VATAmountPerUnit,
		0 AS QuotedPrice,
	0 AS CustomerMasterId


 FROM dbo.tblProduct C 
 
 
WHERE C.IsActive = 1 
AND C.ProductGroupId = 2 
--AND A.EmpInfoId = @empId

		
END
