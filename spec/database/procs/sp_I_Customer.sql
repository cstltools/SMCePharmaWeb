-- =============================================
-- Author:		<Author,Liton>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_I_Customer] 
	(
	            @DetailID INT OUT,
		        @Migo int,
	            @BRANCH NVARCHAR(500),
	            @BRANCHDES NVARCHAR(500),
	            @CustomerCode NVARCHAR(500),
	            @CUSTOMERNAME NVARCHAR(500),
	            @ADDRESS1 NVARCHAR(500),
	            @ADDRESS2 NVARCHAR(500),
	            @CITY NVARCHAR(500),
	            @CONTACTPERSON NVARCHAR(500),
	            @CONTACTNUMBER NVARCHAR(500),
	            @MIOCode NVARCHAR(500),
	            @MIOName NVARCHAR(500),
	            @TerritoryCode NVARCHAR(500),
	            @FECode NVARCHAR(500),
	            @FEName NVARCHAR(500),
	            @DZSMCode NVARCHAR(500),
	            @DZSMName NVARCHAR(500),
	            @SHIPPINGCOND NVARCHAR(500),
	            @SHIPPINGPOINT NVARCHAR(500),
	            @MarketName NVARCHAR(500),
	            @TERMOFPAYMENT NVARCHAR(500),
	            @Verifyed bit
	              
	)
AS
BEGIN
	  
	  INSERT INTO dbo.tblCustomerMasterExcelFileDetail
	          ( MasterID ,
	            BRANCH ,
	            BRANCHDES ,
	            CustomerCode ,
	            CUSTOMERNAME ,
	            ADDRESS1 ,
	            ADDRESS2 ,
	            CITY ,
	            CONTACTPERSON ,
	            CONTACTNUMBER ,
	            MIOCode ,
	            MIOName ,
	            TerritoryCode ,
	            FECode ,
	            FEName ,
	            DZSMCode ,
	            DZSMName ,
	            SHIPPINGCOND ,
	            SHIPPINGPOINT ,
	            MarketName ,
	            TERMOFPAYMENT ,
	            Verifyed
	          )
	  VALUES  (  @Migo ,
	            @BRANCH,
	            @BRANCHDES ,
	            @CustomerCode ,
	            @CUSTOMERNAME ,
	            @ADDRESS1 ,
	            @ADDRESS2 ,
	            @CITY ,
	            @CONTACTPERSON ,
	            @CONTACTNUMBER ,
	            @MIOCode ,
	            @MIOName,
	            @TerritoryCode ,
	            @FECode ,
	            @FEName ,
	            @DZSMCode ,
	            @DZSMName ,
	            @SHIPPINGCOND ,
	            @SHIPPINGPOINT ,
	            @MarketName ,
	            @TERMOFPAYMENT ,
	            @Verifyed 
	          )
	  
     set @DetailID =SCOPE_IDENTITY()     
	
END
