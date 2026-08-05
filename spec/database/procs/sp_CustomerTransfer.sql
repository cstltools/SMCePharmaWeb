-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CustomerTransfer]
	@CustomerMasterExcelFileMasterID INT
AS
BEGIN

DECLARE @CustCode NVARCHAR(MAX)

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
SELECT CustomerCode FROM dbo.tblCustomerMasterExcelFileDetail WHERE MasterID=@CustomerMasterExcelFileMasterID
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@CustCode

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @CountCust INT
SELECT @CountCust= COUNT(*)
 FROM dbo.tblCustMaster WHERE CustomerCode=@CustCode

IF(@CountCust<1)
BEGIN
	


	 INSERT INTO dbo.tblCustMaster
        ( CustomerCode ,
          CategoryId ,
          CustomerName ,
          Address ,
          CellNo ,
          Addrees2 ,
          City ,
          ConPerson ,
          ShippingCond ,
          MarketCode ,
          MarketName ,
          MIACode ,
          MIAName ,
          AreaCode ,
          DisCode ,
          FEName ,
          ComUnitCode ,
          ComUnitName ,
          RegionCode ,
          DZSMName ,
          TermOfPayment ,UploadDate,FixedCustomer,Type
        )
SELECT   

REPLACE(CustomerCode,' ','')CustomerCode,
1,
CUSTOMERNAME,
ADDRESS1, 
REPLACE(CONTACTNUMBER ,' ','')CONTACTNUMBER ,
ADDRESS2  ,
CITY ,
CONTACTPERSON,
REPLACE(SHIPPINGCOND ,' ','')SHIPPINGCOND ,
REPLACE(SHIPPINGPOINT ,' ','')SHIPPINGPOINT ,
MarketName , 
REPLACE(MIOCode ,' ','')MIOCode ,
MIOName,
REPLACE(TerritoryCode ,' ','')TerritoryCode ,
REPLACE(FECode ,' ','')FECode ,
FEName, 
REPLACE(BRANCH , ' ','')BRANCH , 
REPLACE(BRANCHDES,' ','')BRANCHDES,
REPLACE(DZSMCode  ,' ','')DZSMCode  ,
DZSMName, 
REPLACE(TERMOFPAYMENT ,' ','')TERMOFPAYMENT ,
GETDATE(),0,Type
                  
        FROM    dbo.tblCustomerMasterExcelFileDetail
        
        WHERE MasterID=@CustomerMasterExcelFileMasterID AND CustomerCode=@CustCode
END
        
FETCH NEXT FROM @MyCursor
INTO 
@CustCode
END
CLOSE @MyCursor
DEALLOCATE @MyCursor

        
        UPDATE dbo.tblCustomerMasterExcelFileMaster SET Transfer='True' WHERE CustomerMasterExcelFileMasterID=@CustomerMasterExcelFileMasterID
END
