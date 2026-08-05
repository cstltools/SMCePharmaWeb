-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_SubDCStoreOpeningBalanceProcess] 
	
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
       Declare @SubDepotId int 
       Declare @StockQty decimal(18,0)
       Declare @DamageQty decimal(18,0)
       Declare @StockRcvDate datetime
       Declare @ReqId int
       Declare @ReqChildId INT
       Declare @StockInTransfarId INT
       Declare @StockCondition nvarchar(250)
       Declare @SChalanDetailsId INT
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
       SubDepotId ,
       StockQty ,
       DamageQty ,
       StockRcvDate ,
       ReqId ,
       ReqChildId ,
       StockInTransfarId ,
       StockCondition ,
       SChalanDetailsId ,
       MfgDate 
	   FROM dbo.tblSubDepotStore where StockQty>0

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
       @SubDepotId ,
       @StockQty ,
       @DamageQty ,
       @StockRcvDate ,
       @ReqId ,
       @ReqChildId ,
       @StockInTransfarId ,
       @StockCondition ,
       @SChalanDetailsId ,
       @MfgDate  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      INSERT INTO dbo.tblSubDCStore_OpeningBalance
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
          SubDepotId ,
          StockQty ,
          DamageQty ,
          StockRcvDate ,
          ReqId ,
          ReqChildId ,
          StockInTransfarId ,
          StockCondition ,
          SChalanDetailsId ,
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
       @DCStoreId ,
       @StockQty ,
       @DamageQty ,
       @StockRcvDate ,
       @ReqId ,
       @ReqChildId ,
       @StockInTransfarId ,
       @StockCondition ,
       @SChalanDetailsId ,
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
       @SubDepotId ,
       @StockQty ,
       @DamageQty ,
       @StockRcvDate ,
       @ReqId ,
       @ReqChildId ,
       @StockInTransfarId ,
       @StockCondition ,
       @SChalanDetailsId ,
       @MfgDate  

END 

CLOSE db_cursor  
DEALLOCATE db_cursor 




END
