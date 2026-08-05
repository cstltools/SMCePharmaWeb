-- =============================================
-- Author: <Author,JEWEL>
-- Alter date: <Alter Date,06/04/2016,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UD_CustomerMaster] 

 @CustomerMasterId INT,
 @CustomerCode NVARCHAR(MAX) = NULL,
 @CategoryId INT = NULL,
 @CustomerName NVARCHAR(MAX) = NULL,
 @Address NVARCHAR(MAX) = NULL,
 @CellNo NVARCHAR(MAX) = NULL,
 @Addrees2 NVARCHAR(MAX) = NULL,
 @City NVARCHAR(MAX) = NULL,
 @ShippingCond NVARCHAR(MAX) = NULL,
 @MarketCode NVARCHAR(MAX) = NULL,
 @MarketName NVARCHAR(MAX) = NULL,
 @MIACode NVARCHAR(MAX) = NULL,
 @MiaName NVARCHAR(MAX) = NULL,
 @AreaCode NVARCHAR(MAX) = NULL,
 @DisCode NVARCHAR(MAX) = NULL,
 @FEName NVARCHAR(MAX) = NULL,
 @ComUnitCode NVARCHAR(MAX) = NULL,
 @ComUnitName NVARCHAR(MAX) = NULL,
 @RegionCode NVARCHAR(MAX) = NULL,
 @DZSMName NVARCHAR(MAX) = NULL,
 @TermOfPayment NVARCHAR(MAX) = NULL,
 @ConPerson NVARCHAR(MAX) = NULL,


 @FixedCustomer bit,
 @LoginName NVARCHAR(MAX) = NULL,
 @IsActive bit,
 @InActiveDate datetime
 
AS
BEGIN 
 
 UPDATE dbo.tblCustMaster 
 SET ConPerson=@ConPerson,FixedCustomer=@FixedCustomer,IsActive=@IsActive,
 CategoryId = @CategoryId, CustomerName = @CustomerName, Address = @Address,
 CellNo = @CellNo, Addrees2 = @Addrees2, City = @City, ShippingCond = @ShippingCond,
 MarketCode = @MarketCode,MarketName = @MarketName, MIACode = @MIACode,AreaCode = @AreaCode, DisCode = @DisCode, 
 FEName = @FEName, ComUnitCode = @ComUnitCode, ComUnitName = @ComUnitName, RegionCode = @RegionCode, DZSMName = @DZSMName,TermOfPayment = @TermOfPayment
 WHERE CustomerMasterId = @CustomerMasterId
 
END