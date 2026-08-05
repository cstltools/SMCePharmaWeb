CREATE PROCEDURE [dbo].[spInsertReturnInvoice]
(
    @ReturnInvoiceId INT,
    @InvoiceDate datetime,
    @OrderId int,
    @OrderNo nvarchar(50),
    @OrderDate datetime,
    @CustomerMasterId int,
    @ComUnitId int,
    @MiaId int,
    @PaymentTypeId int,
    @TpTotal decimal(18,2),
    @TpDiscount decimal(18,2),
    @TpVat decimal(18,2),
  
   
    
    @DpNAme nvarchar(50), 
    
    @createBy nvarchar(50),
    @Createdate datetime,
    
    @TotalSpecialAmount decimal(18,2),
    
   
    
    @ProductOffer bit,
    @OldTradePolicy bit,
    @Remarks nvarchar(max),
    @FixedCustomer bit,
    @MIACode nvarchar(50),
    @MIAName nvarchar(100),
    @MarketCode nvarchar(50),
    @MarketName nvarchar(100),
    @AreaCode nvarchar(50),
    @DisCode nvarchar(50),
    @FEName nvarchar(100),
    @RegionCode nvarchar(50),
    @DZSMName nvarchar(100),  
    @invoiceid int,
      @DpMob nvarchar(100),
	@Type bit
)
AS
BEGIN
DECLARE @ReturnInvoiceNo nvarchar(50) 

   DECLARE @yearText NVARCHAR(MAX)= SUBSTRING( CONVERT(NVARCHAR(MAX),YEAR(@InvoiceDate)), 3, 3)   
	DECLARE @monthText NVARCHAR(MAX)=(CASE WHEN  LEN(MONTH(@InvoiceDate))=1 THEN '0'+CONVERT(NVARCHAR(MAX),MONTH(@InvoiceDate)) ELSE CONVERT(NVARCHAR(MAX),MONTH(@InvoiceDate)) END)
	DECLARE @dateText NVARCHAR(MAX)=(CASE WHEN  LEN(DAY(@InvoiceDate))=1 THEN '0'+CONVERT(NVARCHAR(MAX),DAY(@InvoiceDate)) ELSE CONVERT(NVARCHAR(MAX),DAY(@InvoiceDate)) END)

SELECT @ReturnInvoiceNo='RIN--'+(@yearText+@monthText+@dateText)+CONVERT(NVARCHAR(MAX),CONVERT(INT,ISNULL(MAX(ReturnInvoiceId),10000))+1001)  FROM tblReturnInvoice 
WHERE CONVERT(date,ReturnInvoiceDate)=CONVERT(date, @InvoiceDate)

    INSERT INTO [dbo].[tblReturnInvoice]
    (
         ReturnInvoiceNo ,  
           ReturnInvoiceDate ,  

            
            CreateBy ,  
             CreateDate ,  




           OrderNo ,  
           OrderDate ,  
           CustomerMasterId ,  
           ComUnitId ,  
           MiaId ,  
           PaymentTypeId ,  
           TpTotal ,  
           TpDiscount ,  
                 
                      
           TpVat ,  
           
          
           OrderId,  
           TotalSpecialAmount,  
            OldTradePolicy,  
             ProductOffer,Remarks,MIACode,MIAName,MarketCode,MarketName,AreaCode,DisCode,FEName,RegionCode,DZSMName,FixedCustomer  ,InvoiceId,IsSalesReturnWithoutOrder,SubInvoiceId,  Types  )
    VALUES
    (
        @ReturnInvoiceNo ,  
           @InvoiceDate ,  

 

            @CreateBy ,  
             @CreateDate ,  




           @OrderNo ,  
           @OrderDate ,  
           @CustomerMasterId ,  
           @ComUnitId ,  
           @MiaId ,  
           @PaymentTypeId ,  
           @TpTotal ,  
           @TpDiscount ,  
                    
                      
           @TpVat ,  
            
            
           @OrderId,  
           @TotalSpecialAmount,  
            @OldTradePolicy,  
             @ProductOffer,@Remarks,@MIACode,@MIAName,@MarketCode,@MarketName,@AreaCode,@DisCode,@FEName,@RegionCode,@DZSMName,@FixedCustomer,  @InvoiceId,'No order',0,@Type)
       
SELECT SCOPE_IDENTITY()
	   end