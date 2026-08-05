CREATE PROCEDURE [dbo].[sp_Save_DAInfo]
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
    @EntryBy INT = NULL,
    @EntryDate DATETIME = NULL
AS
BEGIN
    DECLARE @codeD NVARCHAR(MAX);

    SELECT @codeD = 'DA-' + (CONVERT(NVARCHAR(MAX), (COUNT(DAId) + 10001)))
    FROM dbo.tblDAInfo;

    INSERT INTO tblDAInfo
           (NID,
            Name,
            Address,
            PhoneNo,
            EmergencyContactNo,
            ReferenceName,
            ReferencePhone,
            Remarks,
            ComUnitId,
            JoiningDate,
            IsActive,
            ActiveDate,
            InactiveDate,
            EntryBy,
            EntryDate,
            DACode)
     VALUES
           (@NID,
            @Name,
            @Address,
            @PhoneNo,
            @EmergencyContactNo,
            @ReferenceName,
            @ReferencePhone,
            @Remarks,
            @ComUnitId,
            @JoiningDate,
            @IsActive,
            @ActiveDate,
            @InactiveDate,
            @EntryBy,
            @EntryDate,
            @codeD);

    SELECT SCOPE_IDENTITY();
END
