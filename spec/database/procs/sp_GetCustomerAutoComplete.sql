
CREATE PROCEDURE [dbo].[sp_GetCustomerAutoComplete]
	@Keyword NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT TOP 20
		CustomerMasterId AS CustomerId,
		CustomerCode,
		CustomerName,
		ISNULL(CellNo, '') AS MobileNo
	FROM dbo.tblCustMaster
	WHERE CustomerCode LIKE '%' + @Keyword + '%'
	   OR CustomerName LIKE '%' + @Keyword + '%'
	   OR ISNULL(CellNo, '') LIKE '%' + @Keyword + '%';
END
