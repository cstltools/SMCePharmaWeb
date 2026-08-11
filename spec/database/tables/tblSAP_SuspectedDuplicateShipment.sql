-- Logs Chalans whose full line-item fingerprint (ProductId|Batch|Qty multiset) matches an
-- already-processed tblWHStockInMaster/tblWHStockInDetail shipment under a DIFFERENT ChallanNo,
-- within the last 90 days. Written by sp_SAP_WhStockInMaster (see spec/database/procs/) as part
-- of the Problem 2 fix in docs/ReceiveQty_Permanent_Fix_Plan.md. Purely additive/logging table -
-- a >=3-line match also blocks the new tblWHStockInMaster row from being created until an
-- operator sets Resolved=1 (with ResolutionNote) and re-runs sp_SAP_StockReceive for that
-- ChallanNo; a 1-2 line match is logged only, never blocked.

CREATE TABLE [dbo].[tblSAP_SuspectedDuplicateShipment] (
    [SuspectedDuplicateShipmentId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NewChallanNo]                 NVARCHAR(500) NOT NULL,
    [MatchedWHStockInMasterID]     INT NOT NULL,
    [MatchedChallanNo]             NVARCHAR(500) NULL,
    [LineCount]                    INT NOT NULL,
    [Resolved]                     BIT NOT NULL DEFAULT 0,
    [ResolutionNote]               NVARCHAR(500) NULL,
    [CreatedDate]                  DATETIME NOT NULL DEFAULT GETDATE()
)
