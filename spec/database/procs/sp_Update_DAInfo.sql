
CREATE PROCEDURE [dbo].[sp_Update_DAInfo]
    @DAId INT,
    @NID NVARCHAR(500) = NULL,
    @Name NVARCHAR(500) = NULL,
    @Address NVARCHAR(500) = NULL,
    @PhoneNo NVARCHAR(500) = NULL,
    @EmergencyContactNo NVARCHAR(500) = NULL,
    @ReferenceName NVARCHAR(500) = NULL,
    @ReferencePhone NVARCHAR(500) = NULL,
    @Remarks NVARCHAR(500) = NULL,
    @ComUnitId INT = NULL,
    @JoiningDate DATETIME = NULL,
    @IsActive BIT = NULL,
    @ActiveDate DATETIME = NULL,
    @InactiveDate DATETIME = NULL,
    @UpdateBy INT = NULL,
    @UpdateDate DATETIME = NULL
AS
BEGIN
    UPDATE tblDAInfo
       SET NID = @NID,
           Name = @Name,
           Address = @Address,
           PhoneNo = @PhoneNo,
           EmergencyContactNo = @EmergencyContactNo,
           ReferenceName = @ReferenceName,
           ReferencePhone = @ReferencePhone,
           Remarks = @Remarks,
           ComUnitId = @ComUnitId,
           JoiningDate = @JoiningDate,
           IsActive = @IsActive,
           ActiveDate = @ActiveDate,
           InactiveDate = @InactiveDate,
           UpdateBy = @UpdateBy,
           UpdateDate = @UpdateDate
     WHERE DAId = @DAId;
END