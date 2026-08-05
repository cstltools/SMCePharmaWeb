-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_VerifyCustomer] --- exec sp_StockInMIGOtoCentralStore 3
	@MasterID INT
AS
BEGIN
	    DECLARE @BRANCH NVARCHAR(max)
        DECLARE @CustomerCode NVARCHAR(500)
        DECLARE @MIOCode NVARCHAR(500)
        DECLARE @TerritoryCode NVARCHAR(500)
        DECLARE @FECode NVARCHAR(500)
        DECLARE @DZSMCode NVARCHAR(500)
        DECLARE @SHIPPINGPOINT NVARCHAR(500)
        DECLARE @DetailID INT
        DECLARE @AllOkStatus BIT
        SET @AllOkStatus='1'
--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
	SELECT BRANCH,CustomerCode,MIOCode,TerritoryCode,FECode,DZSMCode,DetailID,SHIPPINGPOINT FROM dbo.tblCustomerMasterExcelFileDetail WHERE MasterID=@MasterID
----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO       
@BRANCH,@CustomerCode,@MIOCode,@TerritoryCode,@FECode,@DZSMCode,@DetailID,@SHIPPINGPOINT

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @BranchData INT
DECLARE @CustData INT
DECLARE @MIOData INT
DECLARE @TerrData INT
DECLARE @FeData INT
DECLARE @DzsmData INT
DECLARE @SHIPPINGPOINTData INT

SELECT @BranchData=COUNT(*) FROM dbo.tblCompanyUnit WHERE ComUnitCode=@BRANCH
SELECT @CustData=COUNT(*) FROM dbo.tblCustMaster WHERE CustomerCode=@CustomerCode
SELECT @MIOData=COUNT(*) FROM dbo.tblMIAInfo WHERE MiaCode=@MIOCode
SELECT @TerrData=COUNT(*) FROM dbo.tblArea WHERE AreaCode=@TerritoryCode
SELECT @FeData=COUNT(*) FROM dbo.tblDistrict WHERE DistrictCode=@FECode
SELECT @DzsmData=COUNT(*) FROM dbo.tblRegion WHERE RegionCode=@DZSMCode
SELECT @SHIPPINGPOINTData=COUNT(*) FROM dbo.tblMarket WHERE MarketCode=@SHIPPINGPOINT

IF(@BranchData>0 AND @CustData<1 AND @MIOData>0 AND @TerrData>0 AND @FeData>0 AND @DzsmData>0 AND @SHIPPINGPOINTData>0)
BEGIN
	UPDATE dbo.tblCustomerMasterExcelFileDetail SET Verifyed='1' WHERE DetailID=@DetailID
END
ELSE
BEGIN
UPDATE dbo.tblCustomerMasterExcelFileDetail SET Verifyed='0' WHERE DetailID=@DetailID
	SET @AllOkStatus='0'
END

FETCH NEXT FROM @MyCursor
INTO       
@BRANCH,@CustomerCode,@MIOCode,@TerritoryCode,@FECode,@DZSMCode,@DetailID,@SHIPPINGPOINT

END
CLOSE @MyCursor
DEALLOCATE @MyCursor


IF(@AllOkStatus='1')
BEGIN
	UPDATE dbo.tblCustomerMasterExcelFileMaster SET VerifyedAll='1' 
	WHERE CustomerMasterExcelFileMasterID=@MasterID 
END
END
