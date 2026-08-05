-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CSOpeningBalanceProcess] 
	
AS
BEGIN
	

	declare @CSOpeningBalanceDate datetime

	set @CSOpeningBalanceDate = Getdate()



	

	   DECLARE @ReceiveId INT
       DECLARE @StorageLocation nvarchar(250)
       DECLARE @ProductId INT
       DECLARE @ProductCode nvarchar(250)
       DECLARE @ProductName nvarchar(250)
       DECLARE @PackSize nvarchar(250)
       DECLARE @BatchNo nvarchar(250)
       DECLARE @Quantity decimal(18,0)
       DECLARE @MfgDate datetime
       DECLARE @ExpDate datetime
       DECLARE @ReceiveDate datetime
       DECLARE @ChalanNo nvarchar(250)
       DECLARE @ChalanDate datetime
       DECLARE @StockInQty decimal(18,0)
       DECLARE @UnitPrice decimal(18,2)
       DECLARE @TotalPrice decimal(18,2)
       DECLARE @VATPerUnit decimal(18,2)
       DECLARE @TotalVAT decimal(18,2)
       DECLARE @TotalAmount decimal(18,2)
       DECLARE @StockCondition nvarchar(250)
       DECLARE @MigoDetailID INT
       DECLARE @DeveloperRemarks nvarchar(500)
       DECLARE @ProductStockType nvarchar(250)
       DECLARE @InternalNoteNo nvarchar(250)






DECLARE db_cursor CURSOR FOR 

SELECT ReceiveId ,
       StorageLocation ,
       ProductId ,
       ProductCode ,
       ProductName ,
       PackSize ,
       BatchNo ,
       Quantity ,
       MfgDate ,
       ExpDate ,
       ReceiveDate ,
       ChalanNo ,
       ChalanDate ,
       StockInQty ,
       UnitPrice ,
       TotalPrice ,
       VATPerUnit ,
       TotalVAT ,
       TotalAmount ,
       StockCondition ,
       MigoDetailID ,
       DeveloperRemarks ,
       ProductStockType ,
       InternalNoteNo FROM dbo.tblCentralStore where Quantity>0

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @ReceiveId ,
       @StorageLocation ,
       @ProductId ,
       @ProductCode ,
       @ProductName ,
       @PackSize ,
       @BatchNo ,
       @Quantity ,
       @MfgDate ,
       @ExpDate ,
       @ReceiveDate ,
       @ChalanNo ,
       @ChalanDate ,
       @StockInQty ,
       @UnitPrice ,
       @TotalPrice ,
       @VATPerUnit ,
       @TotalVAT ,
       @TotalAmount ,
       @StockCondition ,
       @MigoDetailID ,
       @DeveloperRemarks ,
       @ProductStockType ,
       @InternalNoteNo  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      INSERT INTO dbo.tblCentralStore_OpeninigBalance
	           ( CSOpeninigBalanceDate ,
	             ReceiveId ,
	             StorageLocation ,
	             ProductId ,
	             ProductCode ,
	             ProductName ,
	             PackSize ,
	             BatchNo ,
	             Quantity ,
	             MfgDate ,
	             ExpDate ,
	             ReceiveDate ,
	             ChalanNo ,
	             ChalanDate ,
	             StockInQty ,
	             UnitPrice ,
	             TotalPrice ,
	             VATPerUnit ,
	             TotalVAT ,
	             TotalAmount ,
	             StockCondition ,
	             MigoDetailID ,
	             DeveloperRemarks ,
	             ProductStockType ,
	             InternalNoteNo
	           )
	   VALUES  ( CONVERT(nvarchar(11),@CSOpeningBalanceDate,106) , -- CSOpeninigBalanceDate - datetime
	             @ReceiveId ,
       @StorageLocation ,
       @ProductId ,
       @ProductCode ,
       @ProductName ,
       @PackSize ,
       @BatchNo ,
       @Quantity ,
       @MfgDate ,
       @ExpDate ,
       @ReceiveDate ,
       @ChalanNo ,
       @ChalanDate ,
       @StockInQty ,
       @UnitPrice ,
       @TotalPrice ,
       @VATPerUnit ,
       @TotalVAT ,
       @TotalAmount ,
       @StockCondition ,
       @MigoDetailID ,
       @DeveloperRemarks ,
       @ProductStockType ,
       @InternalNoteNo  
	           )
	  
      FETCH NEXT FROM db_cursor INTO @ReceiveId ,
       @StorageLocation ,
       @ProductId ,
       @ProductCode ,
       @ProductName ,
       @PackSize ,
       @BatchNo ,
       @Quantity ,
       @MfgDate ,
       @ExpDate ,
       @ReceiveDate ,
       @ChalanNo ,
       @ChalanDate ,
       @StockInQty ,
       @UnitPrice ,
       @TotalPrice ,
       @VATPerUnit ,
       @TotalVAT ,
       @TotalAmount ,
       @StockCondition ,
       @MigoDetailID ,
       @DeveloperRemarks ,
       @ProductStockType ,
       @InternalNoteNo   
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 


update   tblOrderDetail set DiscountPercent=0, ISGiftProduct=1  where  OrderDetailId in (

select tblOrderDetail.OrderDetailId from tblOrderDetail 

inner join tblOrder  on tblOrderDetail.OrderId=tblOrder.OrderId
inner join tblProduct on tblOrderDetail.ProductCode=tblProduct.ProductCode
where   DiscountPercent>0
and ProductGroupId=3)

END
