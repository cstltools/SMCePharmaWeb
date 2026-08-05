-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CustomerTransferTagChange]
	@CustomerTagChangeExcelFileMasterID INT
AS
BEGIN
	
	
	DECLARE @BRANCH NVARCHAR(MAX)
	DECLARE @BRANCHDES NVARCHAR(MAX)
	DECLARE @CUSTOMERNAME NVARCHAR(MAX)
	DECLARE @CustomerCode NVARCHAR(MAX)
	DECLARE @ADDRESS1 NVARCHAR(MAX)
	DECLARE @ADDRESS2 NVARCHAR(MAX)
	DECLARE @CITY NVARCHAR(MAX)
	DECLARE @CONTACTPERSON NVARCHAR(MAX)
	DECLARE @CONTACTNUMBER NVARCHAR(MAX)
	DECLARE @MIOCode NVARCHAR(MAX)
	DECLARE @MIOName NVARCHAR(MAX)
	DECLARE @TerritoryCode NVARCHAR(MAX)
	DECLARE @FECode NVARCHAR(MAX)
	DECLARE @FEName NVARCHAR(MAX)
	DECLARE @DZSMCode NVARCHAR(MAX)
	DECLARE @DZSMName NVARCHAR(MAX)
	DECLARE @SHIPPINGCOND NVARCHAR(MAX)
	DECLARE @SHIPPINGPOINT NVARCHAR(MAX)
	DECLARE @MarketName NVARCHAR(MAX)

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR

SELECT 
        REPLACE(BRANCH ,' ','')BRANCH,
        REPLACE(BRANCHDES ,' ','')BRANCHDES,
       CUSTOMERNAME,
        ADDRESS1,
        ADDRESS2,
       CITY,
        CONTACTPERSON,
        REPLACE(CONTACTNUMBER ,' ','')CONTACTNUMBER,
        REPLACE(MIOCode ,' ','')MIOCode,
        MIOName,
        REPLACE(TerritoryCode ,' ','')TerritoryCode,
        REPLACE(FECode ,' ','')FECode,
      FEName,
        REPLACE(DZSMCode ,' ','')DZSMCode,
        DZSMName,
        REPLACE(SHIPPINGCOND ,' ','')SHIPPINGCOND,
        REPLACE(SHIPPINGPOINT ,' ','')SHIPPINGPOINT,
      MarketName,
        REPLACE(CustomerCode,' ','')CustomerCode
        FROM dbo.tblCustomerMasterTagChangeExcelFileDetail WHERE MasterID=@CustomerTagChangeExcelFileMasterID AND Verifyed='True'	
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO       
		@BRANCH ,
        @BRANCHDES ,
        
        @CUSTOMERNAME ,
        @ADDRESS1 ,
        @ADDRESS2 ,
        @CITY ,
        @CONTACTPERSON ,
        @CONTACTNUMBER ,
        @MIOCode ,
        @MIOName ,
        @TerritoryCode ,
        @FECode ,
        @FEName ,
        @DZSMCode ,
        @DZSMName ,
        @SHIPPINGCOND ,
        @SHIPPINGPOINT ,
        @MarketName ,@CustomerCode

WHILE @@FETCH_STATUS = 0
BEGIN



UPDATE dbo.tblCustMaster SET 

        CustomerName=@CUSTOMERNAME ,
        Address=@ADDRESS1 ,
        CellNo=@CONTACTNUMBER ,
        
        Addrees2=@ADDRESS2 ,
        City=@CITY ,
        ConPerson=@CONTACTPERSON ,
        ShippingCond=@SHIPPINGCOND ,
        MarketCode=@SHIPPINGPOINT ,
        MarketName=@MarketName ,
        MIACode=@MIOCode ,
        MIAName=@MIOName ,
        AreaCode=@TerritoryCode ,
        DisCode=@FECode ,
        FEName =@FEName,
        ComUnitCode=@BRANCH ,
        ComUnitName=@BRANCHDES ,
        RegionCode=@DZSMCode ,
        DZSMName=@DZSMName  WHERE CustomerCode=@CustomerCode
        









FETCH NEXT FROM @MyCursor
INTO       
		@BRANCH ,
        @BRANCHDES ,
        
        @CUSTOMERNAME ,
        @ADDRESS1 ,
        @ADDRESS2 ,
        @CITY ,
        @CONTACTPERSON ,
        @CONTACTNUMBER ,
        @MIOCode ,
        @MIOName ,
        @TerritoryCode ,
        @FECode ,
        @FEName ,
        @DZSMCode ,
        @DZSMName ,
        @SHIPPINGCOND ,
        @SHIPPINGPOINT ,
        @MarketName ,@CustomerCode
END
CLOSE @MyCursor
DEALLOCATE @MyCursor

UPDATE dbo.tblCustomerMasterTagChangeExcelFileMaster SET Transfer='True' WHERE CustomerTagChangeExcelFileMasterID=@CustomerTagChangeExcelFileMasterID
	
END
