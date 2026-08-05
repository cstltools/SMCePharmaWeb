-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_StockInMIGOtoCentralStore] --- exec sp_StockInMIGOtoCentralStore 1
	@MigoMasterID_In INT
AS
BEGIN

	
	
	
	DECLARE @ReceiveIdMAX INT
	
	
        DECLARE @MigoDetailID INT
        DECLARE @MigoMasterID INT
        DECLARE @ShipToParty NVARCHAR(500)
        DECLARE @PONo NVARCHAR(500)
        DECLARE @PODate DATETIME
        DECLARE @ItemNo NVARCHAR(500)
        DECLARE @OrderDocNo NVARCHAR(500)
        DECLARE @OrderDocDate DATETIME
        DECLARE @DeliveryDocNo NVARCHAR(500)
        DECLARE @DeliveryDocDate DATETIME
        DECLARE @LMID NVARCHAR(500)
        DECLARE @LMIDDescription NVARCHAR(MAX)
        DECLARE @Batch NVARCHAR(MAX)
        DECLARE @ExpDate DATETIME
        DECLARE @MfgDate DATETIME
        DECLARE @Qty DECIMAL(18,0)
        DECLARE @VATChallan NVARCHAR(500)
        DECLARE @BilltoParty NVARCHAR(500)
        DECLARE @InvoiceNo NVARCHAR(500)
        DECLARE @InvoiceDate DATETIME
        DECLARE @CaseNoofShipper NVARCHAR(500)
        DECLARE @VAT DECIMAL(18,2)
        DECLARE @Amount DECIMAL(18,2)
        DECLARE @Total DECIMAL(18,2)
        DECLARE @TransportNo NVARCHAR(500)
--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
	SELECT R.MigoDetailID ,
           R.MigoMasterID ,
           R.ShipToParty ,
           R.PONo ,
           R.PODate ,
           R.ItemNo ,
           R.OrderDocNo ,
           R.OrderDocDate ,
           R.DeliveryDocNo ,
           R.DeliveryDocDate ,
           R.LMID ,
           R.LMIDDescription ,
           R.Batch ,
           R.ExpDate ,
           R.MfgDate ,
           R.Qty ,
           R.VATChallan ,
           R.BilltoParty ,
           R.InvoiceNo ,
           R.InvoiceDate ,
           R.CaseNoofShipper ,
           R.VAT ,
           R.Amount ,
           R.Total ,
           R.TransportNo FROM dbo.tblMIGOMaster M INNER JOIN dbo.tblMIGODetail R ON R.MigoMasterID = M.MigoMasterID  WHERE M.StockUpload=0 AND M.MigoMasterID=@MigoMasterID_In
----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO       @MigoDetailID ,
           @MigoMasterID ,
           @ShipToParty ,
           @PONo ,
           @PODate ,
           @ItemNo ,
           @OrderDocNo ,
           @OrderDocDate ,
           @DeliveryDocNo ,
           @DeliveryDocDate , 
           @LMID ,
           @LMIDDescription ,
           @Batch ,
           @ExpDate ,
           @MfgDate ,
           @Qty ,
           @VATChallan ,
           @BilltoParty ,
           @InvoiceNo ,
           @InvoiceDate ,
           @CaseNoofShipper ,
           @VAT ,
           @Amount ,
           @Total ,
           @TransportNo
WHILE @@FETCH_STATUS = 0
BEGIN

SELECT @ReceiveIdMAX=(ISNULL(MAX(ReceiveId),0)+1) FROM tblCentralStore

INSERT INTO dbo.tblCentralStore
        ( ReceiveId ,
          StorageLocation ,
          ProductCode ,
          ProductName ,
          PackSize ,
          BatchNo ,
          Quantity ,
          ExpDate ,
          MfgDate,
          ReceiveDate ,
          ChalanNo ,
          ChalanDate ,
          InternalNoteNo ,
          StockInQty ,
          UnitPrice ,
          VATPerUnit,
          TotalPrice,
          TotalVAT,
          TotalAmount ,
          StockCondition,
          MigoDetailID
        )
VALUES  ( @ReceiveIdMAX , -- ReceiveId - int
          NULL , -- StorageLocation - nvarchar(max)
          @LMID , -- ProductCode - nvarchar(50)
          @LMIDDescription , -- ProductName - nvarchar(max)
          (SELECT PackSize FROM dbo.tblProduct WHERE ProductCode=@LMID) , -- PackSize - nvarchar(50)
          @Batch , -- BatchNo - nvarchar(max)
          @Qty , -- Quantity - decimal
          @ExpDate , -- ExpDate - datetime
          @MfgDate,
          GETDATE() , -- ReceiveDate - datetime
          @DeliveryDocNo, -- ChalanNo - nvarchar(max)
          @DeliveryDocDate , -- ChalanDate - datetime
          @OrderDocNo , -- InternalNoteNo - nvarchar(50)
          @Qty , -- StockInQty - decimal
          (@Amount/@Qty) , -- UnitPrice - decimal
          (@VAT/@Qty) , -- VATPerUnit - decimal
          @Amount,--TotalPrice
          @VAT,--TotalVAT
          @Total , -- TotalAmount - decimal
          N'Available',  -- StockCondition - nvarchar(50)
          @MigoDetailID
        )


 
FETCH NEXT FROM @MyCursor
INTO @MigoDetailID ,
           @MigoMasterID ,
           @ShipToParty ,
           @PONo ,
           @PODate ,
           @ItemNo ,
           @OrderDocNo ,
           @OrderDocDate ,
           @DeliveryDocNo ,
           @DeliveryDocDate , 
           @LMID ,
           @LMIDDescription ,
           @Batch ,
           @ExpDate ,
           @MfgDate ,
           @Qty ,
           @VATChallan ,
           @BilltoParty ,
           @InvoiceNo ,
           @InvoiceDate ,
           @CaseNoofShipper ,
           @VAT ,
           @Amount ,
           @Total ,
           @TransportNo
END
CLOSE @MyCursor
DEALLOCATE @MyCursor
	
	
	UPDATE dbo.tblMIGOMaster SET StockUpload=1 WHERE MigoMasterID=@MigoMasterID_In
END
