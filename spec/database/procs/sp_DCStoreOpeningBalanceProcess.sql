-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_DCStoreOpeningBalanceProcess 
	
AS
BEGIN
	

	declare @DCStoreOpeningBalanceDate datetime

	set @DCStoreOpeningBalanceDate = Getdate()



	

	 Declare @DCStoreId INT
       Declare @StorageLocation nvarchar(250)
       Declare @ProductCode nvarchar(250)
       Declare @ProductName nvarchar(500)
       Declare @PackSize nvarchar(250)
       Declare @BatchNo nvarchar(250)
       Declare @TotalQuantity decimal(18,0)
       Declare @ExpDate datetime
       Declare @ReceiveDate datetime
       Declare @ChalanNo nvarchar(500)
       Declare @ChalanDate datetime
       Declare @ComUnitId int 
       Declare @StockQty decimal(18,0)
       Declare @DamageQty decimal(18,0)
       Declare @StockRcvDate datetime
       Declare @ReqId int
       Declare @ReqChildId INT
       Declare @StockInTransfarId INT
       Declare @StockCondition nvarchar(250)
       Declare @ChalanDetailsId INT
       Declare @MfgDate datetime






DECLARE db_cursor CURSOR FOR 

  SELECT 
       DCStoreId ,
       StorageLocation ,
       ProductCode ,
       ProductName ,
       PackSize ,
       BatchNo ,
       TotalQuantity ,
       ExpDate ,
       ReceiveDate ,
       ChalanNo ,
       ChalanDate ,
       ComUnitId ,
       StockQty ,
       DamageQty ,
       StockRcvDate ,
       ReqId ,
       ReqChildId ,
       StockInTransfarId ,
       StockCondition ,
       ChalanDetailsId ,
       MfgDate FROM dbo.tblDCStore where StockQty>0

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @DCStoreId ,
       @StorageLocation ,
       @ProductCode ,
       @ProductName ,
       @PackSize ,
       @BatchNo ,
       @TotalQuantity ,
       @ExpDate ,
       @ReceiveDate ,
       @ChalanNo ,
       @ChalanDate ,
       @ComUnitId ,
       @StockQty ,
       @DamageQty ,
       @StockRcvDate ,
       @ReqId ,
       @ReqChildId ,
       @StockInTransfarId ,
       @StockCondition ,
       @ChalanDetailsId ,
       @MfgDate  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      INSERT INTO dbo.tblDCStore_OpeningBalance
        (DCOpeningBalanceDate ,
          DCStoreId ,
          StorageLocation ,
          ProductCode ,
          ProductName ,
          PackSize ,
          BatchNo ,
          TotalQuantity ,
          ExpDate ,
          ReceiveDate ,
          ChalanNo ,
          ChalanDate ,
          ComUnitId ,
          StockQty ,
          DamageQty ,
          StockRcvDate ,
          ReqId ,
          ReqChildId ,
          StockInTransfarId ,
          StockCondition ,
          ChalanDetailsId ,
          MfgDate
        )
VALUES  (convert(nvarchar(11),@DCStoreOpeningBalanceDate,106) , -- DCOpeningBalanceDate - datetime
       @DCStoreId ,
       @StorageLocation ,
       @ProductCode ,
       @ProductName ,
       @PackSize ,
       @BatchNo ,
       @TotalQuantity ,
       @ExpDate ,
       @ReceiveDate ,
       @ChalanNo ,
       @ChalanDate ,
       @ComUnitId ,
       @StockQty ,
       @DamageQty ,
       @StockRcvDate ,
       @ReqId ,
       @ReqChildId ,
       @StockInTransfarId ,
       @StockCondition ,
       @ChalanDetailsId ,
       @MfgDate  
        )
	  
      FETCH NEXT FROM db_cursor INTO @DCStoreId ,
       @StorageLocation ,
       @ProductCode ,
       @ProductName ,
       @PackSize ,
       @BatchNo ,
       @TotalQuantity ,
       @ExpDate ,
       @ReceiveDate ,
       @ChalanNo ,
       @ChalanDate ,
       @ComUnitId ,
       @StockQty ,
       @DamageQty ,
       @StockRcvDate ,
       @ReqId ,
       @ReqChildId ,
       @StockInTransfarId ,
       @StockCondition ,
       @ChalanDetailsId ,
       @MfgDate  

END 

CLOSE db_cursor  
DEALLOCATE db_cursor 




END
