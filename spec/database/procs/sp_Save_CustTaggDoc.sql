-- Added 2026-08-09 for the CustomerEntry.aspx Doctor multi-select requirement
-- (see spec/requirements.md). Mirrors sp_Save_ProductDCDetails/sp_Save_CustProductLineDetail's
-- shape: one call per selected doctor, called in a loop from CustomerInfoDAL.SaveInfo after the
-- customer row itself is saved.
CREATE PROCEDURE [dbo].[sp_Save_CustTaggDoc]
    @CustomerMasterId INT,
    @DoctorId INT
AS
BEGIN
    INSERT INTO [dbo].[tblCustTaggDoc] ([CustomerMasterId], [DoctorId])
    VALUES (@CustomerMasterId, @DoctorId)
END
