CREATE PROCEDURE [dbo].[sp_RPT_DuplicateCustomerCode]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		CustomerCode,
		COUNT(CustomerCode) AS DuplicateCount
	FROM dbo.tblCustMaster WITH (NOLOCK)
	GROUP BY CustomerCode
	HAVING COUNT(CustomerCode) > 1
	ORDER BY DuplicateCount DESC, CustomerCode;

END
