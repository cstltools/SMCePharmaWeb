CREATE PROCEDURE [dbo].[sp_DeleteArchiveAttendanceData]
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @FromDate IS NULL
        SET @FromDate = '19000101';
    IF @ToDate IS NULL
        SET @ToDate = '99991231';

    IF @FromDate > @ToDate
    BEGIN
        RAISERROR('FromDate cannot be greater than ToDate.', 16, 1);
        RETURN;
    END;

    BEGIN TRAN;
    BEGIN TRY
        -- Archive Attendance data before deletion
        INSERT INTO dbo.tblMarketAttendance_Master_webapiDeleteArchive
        (
            AttendanceId,
            EmpInfoId,
            PunchInTime,
            PInLat,
            PInLog,
            POutRemarks,
            AttendanceDate,
            PINCreatedDateTime,
            POUTCreatedDateTime,
            ApprovalStatus,
            ShiftId,
            UserRoleID,
            ApprovedBy,
            ApprovedDate,
            AttType,
            AttAddress,
            GroupId,
            RegionId,
            AreaId,
            TerritoryId,
            SubTerritoryId,
            MarketId,
            GroupName_Att,
            RegionName_Att,
            AreaName_Att,
            TerritoryName_Att,
            SubTerritoryName_Att,
            MarketName_Att,
            GroupCode_Att,
            RegionCode_Att,
            AreaCode_Att,
            TerritoryCode_Att,
            SubTerritoryCode_Att,
            MarketCode_Att,
            isGone,
            isGoneDate,
            ArchiveDate
        )
        SELECT
            a.AttendanceId,
            a.EmpInfoId,
            a.PunchInTime,
            a.PInLat,
            a.PInLog,
            a.POutRemarks,
            a.AttendanceDate,
            a.PINCreatedDateTime,
            a.POUTCreatedDateTime,
            a.ApprovalStatus,
            a.ShiftId,
            a.UserRoleID,
            a.ApprovedBy,
            a.ApprovedDate,
            a.AttType,
            a.AttAddress,
            a.GroupId,
            a.RegionId,
            a.AreaId,
            a.TerritoryId,
            a.SubTerritoryId,
            a.MarketId,
            a.GroupName_Att,
            a.RegionName_Att,
            a.AreaName_Att,
            a.TerritoryName_Att,
            a.SubTerritoryName_Att,
            a.MarketName_Att,
            a.GroupCode_Att,
            a.RegionCode_Att,
            a.AreaCode_Att,
            a.TerritoryCode_Att,
            a.SubTerritoryCode_Att,
            a.MarketCode_Att,
            a.isGone,
            a.isGoneDate,
            GETDATE() AS ArchiveDate
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tblMarketAttendance_Master_webapi a
        WHERE a.AttendanceDate >= @FromDate
          AND a.AttendanceDate < DATEADD(DAY, 1, @ToDate);

        -- Delete Attendance records
        DELETE a
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tblMarketAttendance_Master_webapi a
        WHERE a.AttendanceDate >= @FromDate
          AND a.AttendanceDate < DATEADD(DAY, 1, @ToDate);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
