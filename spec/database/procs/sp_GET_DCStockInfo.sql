-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_GET_DCStockInfo] 

 @DcId NVARCHAR(50)

AS
BEGIN
	
	SELECT DCStoreId,ProductCode,ProductName,PackSize,BatchNo,ChalanNo,ChalanDate,StockQty FROM dbo.tblDCStore
	WHERE ComUnitId = @DcId AND StockQty > 0
	
END


--SELECT * FROM dbo.tblCustomerCreditLimit
--INNER JOIN dbo.tblCustMaster ON tblCustMaster.CustomerMasterId = tblCustomerCreditLimit.CustomerMasterId
--WHERE CustomerCode IN ('17686')


