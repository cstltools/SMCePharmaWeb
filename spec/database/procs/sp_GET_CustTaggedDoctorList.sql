-- Added 2026-08-09 for the CustomerEntry.aspx Doctor multi-select requirement
-- (see spec/requirements.md). Returns the doctors currently tagged to a customer, for
-- pre-selecting the multi-select on edit.
CREATE PROCEDURE [dbo].[sp_GET_CustTaggedDoctorList]
    @CustomerMasterId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DoctorId
    FROM dbo.tblCustTaggDoc WITH (NOLOCK)
    WHERE CustomerMasterId = @CustomerMasterId
END
