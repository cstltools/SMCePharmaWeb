-- Added 2026-08-09 for the CustomerEntry.aspx Doctor multi-select requirement
-- (see spec/requirements.md). Fixed WHERE clause, no dynamic SQL - unlike sp_Get_DoctorList's
-- @Parm (a raw SQL fragment concatenated into the query, see docs/security.md SQL-injection
-- findings), this proc takes no caller-supplied filter text.
CREATE PROCEDURE [dbo].[sp_GET_DoctorList_ForCustTagging]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DoctorId, DoctorCode, DoctorName
    FROM dbo.tblDoctorMaster WITH (NOLOCK)
    WHERE IsActive = 1
      AND DoctorCode IS NOT NULL
      AND ApprovalStatus = '2'
    ORDER BY DoctorCode
END
