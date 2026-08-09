-- Customer <-> Doctor tagging (many-to-many). Added 2026-08-09 for the CustomerEntry.aspx
-- Doctor multi-select requirement (see spec/requirements.md).
--
-- DoctorId/CustomerMasterId reference tblDoctorMaster.DoctorId / tblCustMaster.CustomerMasterId
-- (both plain int PKs, no FK constraints - consistent with this database's existing convention of
-- not declaring FKs, e.g. tblCustProductLine/tblProductDCDetails have none either).

CREATE TABLE [dbo].[tblCustTaggDoc] (
    [CustTaggDocId]    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CustomerMasterId] INT NOT NULL,
    [DoctorId]         INT NOT NULL,
    CONSTRAINT [UQ_tblCustTaggDoc_Customer_Doctor] UNIQUE ([CustomerMasterId], [DoctorId])
)
