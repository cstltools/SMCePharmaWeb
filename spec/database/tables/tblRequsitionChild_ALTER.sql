-- Problem 3 fix (docs/ReceiveQty_Permanent_Fix_Plan.md): tblRequsitionChild had no reference
-- back to the tblWHStockInDetail row it was created from, so sp_SAP_StockInTransfer had to
-- re-derive the pairing via ProductCode+BatchNo, which is ambiguous whenever more than one
-- detail row shares both. Additive, nullable - existing rows are unaffected; sp_SAP_STODetails
-- now populates this 1:1 on every new row, and sp_SAP_StockInTransfer joins on it when present,
-- falling back to the old ProductCode+BatchNo join only for legacy rows where it's NULL.

ALTER TABLE [dbo].[tblRequsitionChild]
    ADD [WHStockInDetailID] INT NULL
