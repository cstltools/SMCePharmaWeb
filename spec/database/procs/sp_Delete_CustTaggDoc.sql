-- Added 2026-08-09 for the CustomerEntry.aspx Doctor multi-select requirement
-- (see spec/requirements.md). Mirrors sp_Delete_ProductDCDetails's shape: caller deletes all
-- existing mappings for the customer before re-inserting the currently selected set
-- (delete-then-insert sync, not a diff/merge).
CREATE PROCEDURE [dbo].[sp_Delete_CustTaggDoc]
    @CustomerMasterId INT
AS
BEGIN
    DELETE FROM dbo.tblCustTaggDoc WHERE CustomerMasterId = @CustomerMasterId
END
