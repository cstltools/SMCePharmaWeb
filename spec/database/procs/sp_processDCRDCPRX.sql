CREATE PROCEDURE [dbo].[sp_processDCRDCPRX] 

   
AS
BEGIN


DECLARE @PrescriptionId INT, @DocTPDetailsId INT, @DcrId INT
DECLARE @SMCTypeId INT, @SMCType NVARCHAR(200)

-- Cursor for tbl_PrescriptionMaster
DECLARE prescription_cursor CURSOR FOR
SELECT pr.PrescriptionId, m.SMCTypeId, ss.SMCType
FROM tbl_PrescriptionMaster pr
INNER JOIN tblDoctorMaster m ON m.DoctorId = pr.DoctorId
INNER JOIN tblSMCType ss ON m.SMCTypeId = ss.SMCTypeId
WHERE pr.SmcTypeId_RX IS NULL OR pr.SMCType_RX IS NULL

OPEN prescription_cursor
FETCH NEXT FROM prescription_cursor INTO @PrescriptionId, @SMCTypeId, @SMCType

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE tbl_PrescriptionMaster
    SET 
        SmcTypeId_RX = @SMCTypeId,
        SMCType_RX = @SMCType
    WHERE PrescriptionId = @PrescriptionId

    FETCH NEXT FROM prescription_cursor INTO @PrescriptionId, @SMCTypeId, @SMCType
END

CLOSE prescription_cursor
DEALLOCATE prescription_cursor


-- Cursor for tbl_DoctorTourPlanDetail
DECLARE dv_cursor CURSOR FOR
SELECT dcd.DocTPDetailsId, m.SMCTypeId, ss.SMCType
FROM tblDoctorMaster m
INNER JOIN tbl_DoctorTourPlanDetail dcd ON m.DoctorId = dcd.DoctorId
INNER JOIN tblSMCType ss ON m.SMCTypeId = ss.SMCTypeId
WHERE dcd.SMCTypeId_DV IS NULL OR dcd.SMCType_DV IS NULL

OPEN dv_cursor
FETCH NEXT FROM dv_cursor INTO @DocTPDetailsId, @SMCTypeId, @SMCType

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE tbl_DoctorTourPlanDetail
    SET 
        SMCTypeId_DV = @SMCTypeId,
        SMCType_DV = @SMCType
    WHERE DocTPDetailsId = @DocTPDetailsId

    FETCH NEXT FROM dv_cursor INTO @DocTPDetailsId, @SMCTypeId, @SMCType
END

CLOSE dv_cursor
DEALLOCATE dv_cursor


-- Cursor for tbl_DCRInfo
DECLARE dcr_cursor CURSOR FOR
SELECT dcd.DcrId, m.SMCTypeId, ss.SMCType
FROM tblDoctorMaster m
INNER JOIN tbl_DCRInfo dcd ON m.DoctorId = dcd.DoctorId
INNER JOIN tblSMCType ss ON m.SMCTypeId = ss.SMCTypeId
WHERE dcd.SmcTypeId_DCR IS NULL OR dcd.SMCType_DCR IS NULL

OPEN dcr_cursor
FETCH NEXT FROM dcr_cursor INTO @DcrId, @SMCTypeId, @SMCType

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE tbl_DCRInfo
    SET 
        SmcTypeId_DCR = @SMCTypeId,
        SMCType_DCR = @SMCType
    WHERE DcrId = @DcrId

    FETCH NEXT FROM dcr_cursor INTO @DcrId, @SMCTypeId, @SMCType
END

CLOSE dcr_cursor
DEALLOCATE dcr_cursor
end