CREATE PROCEDURE [dbo].[sp_DeleteArchiveTourPlanData]
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
        -- Archive TourPlan Master data before deletion
        INSERT INTO dbo.tblTourPlanMasterDeleteArchive
        (
            TPMaster,
            MonthValue,
            YearValue,
            EmpInfoId,
            IsFinalSubmit,
            ApprovalStatus,
            ApprovedBy,
            ApprovedDate,
            FinalSubmitRemarks,
            ApprovalRemarks,
            ArchiveDate
        )
        SELECT
            tm.TPMaster,
            tm.MonthValue,
            tm.YearValue,
            tm.EmpInfoId,
            tm.IsFinalSubmit,
            tm.ApprovalStatus,
            tm.ApprovedBy,
            tm.ApprovedDate,
            tm.FinalSubmitRemarks,
            tm.ApprovalRemarks,
            GETDATE() AS ArchiveDate
        FROM dbo.tbl_TourPlanMaster tm
        WHERE tm.MonthValue >= MONTH(@FromDate)
          AND tm.YearValue >= YEAR(@FromDate)
          AND (tm.MonthValue < MONTH(@ToDate) OR (tm.MonthValue = MONTH(@ToDate) AND tm.YearValue <= YEAR(@ToDate)));

        -- Archive TourPlan Info data before deletion
        INSERT INTO dbo.tblTourPlanInfoDeleteArchive
        (
            TourPlanId,
            SMId,
            CustomerMasterId,
            ShiftId,
            TourTypeId,
            TPId,
            Comment,
            TourPlanDate,
            EmpInfoId,
            IsMarketWise,
            IsApproved,
            CreatedBy,
            CreatedDate,
            UpdateBy,
            UpdateDate,
            ApprovedBy,
            ApprovedDate,
            TPMaster,
            GroupId,
            RegionId,
            AreaId,
            TerritoryId,
            SubTerritoryId,
            MarketId,
            GroupName,
            RegionName,
            AreaName,
            TerritoryName,
            SubTerritoryName,
            MarketName,
            GroupCode_TP,
            RegionCode_TP,
            AreaCode_TP,
            TerritoryCode_TP,
            SubTerritoryCode_TP,
            MarketCode_TP,
            SerialNo,
            IsMorning,
            IsEvening,
            IsStartTime,
            Starttime,
            IsEndtime,
            Endtime,
            VisitedWithEmpInfoId,
            GroupIdEnd,
            RegionIdEnd,
            AreaIdEnd,
            TerritoryIdEnd,
            SubTerritoryIdEnd,
            MarketIdEnd,
            GroupNameEnd,
            RegionNameEnd,
            AreaNameEnd,
            TerritoryNameEnd,
            SubTerritoryNameEnd,
            MarketNameEnd,
            GroupCode_TPEnd,
            RegionCode_TPEnd,
            AreaCode_TPEnd,
            TerritoryCode_TPEnd,
            SubTerritoryCode_TPEnd,
            MarketCode_TPEnd,
            IsMarketVisit,
            IsOtherVisit,
            OtherMarketNameVisited,
            Objective,
            ArchiveDate
        )
        SELECT
            ti.TourPlanId,
            ti.SMId,
            ti.CustomerMasterId,
            ti.ShiftId,
            ti.TourTypeId,
            ti.TPId,
            ti.Comment,
            ti.TourPlanDate,
            ti.EmpInfoId,
            ti.IsMarketWise,
            ti.IsApproved,
            ti.CreatedBy,
            ti.CreatedDate,
            ti.UpdateBy,
            ti.UpdateDate,
            ti.ApprovedBy,
            ti.ApprovedDate,
            ti.TPMaster,
            ti.GroupId,
            ti.RegionId,
            ti.AreaId,
            ti.TerritoryId,
            ti.SubTerritoryId,
            ti.MarketId,
            ti.GroupName,
            ti.RegionName,
            ti.AreaName,
            ti.TerritoryName,
            ti.SubTerritoryName,
            ti.MarketName,
            ti.GroupCode_TP,
            ti.RegionCode_TP,
            ti.AreaCode_TP,
            ti.TerritoryCode_TP,
            ti.SubTerritoryCode_TP,
            ti.MarketCode_TP,
            ti.SerialNo,
            ti.IsMorning,
            ti.IsEvening,
            ti.IsStartTime,
            ti.Starttime,
            ti.IsEndtime,
            ti.Endtime,
            ti.VisitedWithEmpInfoId,
            ti.GroupIdEnd,
            ti.RegionIdEnd,
            ti.AreaIdEnd,
            ti.TerritoryIdEnd,
            ti.SubTerritoryIdEnd,
            ti.MarketIdEnd,
            ti.GroupNameEnd,
            ti.RegionNameEnd,
            ti.AreaNameEnd,
            ti.TerritoryNameEnd,
            ti.SubTerritoryNameEnd,
            ti.MarketNameEnd,
            ti.GroupCode_TPEnd,
            ti.RegionCode_TPEnd,
            ti.AreaCode_TPEnd,
            ti.TerritoryCode_TPEnd,
            ti.SubTerritoryCode_TPEnd,
            ti.MarketCode_TPEnd,
            ti.IsMarketVisit,
            ti.IsOtherVisit,
            ti.OtherMarketNameVisited,
            ti.Objective,
            GETDATE() AS ArchiveDate
        FROM dbo.tbl_TourPlanInfo ti
        LEFT JOIN dbo.tbl_TourPlanMaster tm
            ON ti.TPId = tm.TPMaster
        WHERE ti.TourPlanDate >= @FromDate
          AND ti.TourPlanDate < DATEADD(DAY, 1, @ToDate);

        -- Delete TourPlan Info records
        DELETE ti
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_TourPlanInfo ti
        LEFT JOIN SalesDisDB_SMC_NEWDB_Dynamic..tbl_TourPlanMaster tm
            ON ti.TPId = tm.TPMaster
        WHERE ti.TourPlanDate >= @FromDate
          AND ti.TourPlanDate < DATEADD(DAY, 1, @ToDate);

        -- Delete TourPlan Master records
        DELETE tm
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_TourPlanMaster tm
        WHERE tm.MonthValue >= MONTH(@FromDate)
          AND tm.YearValue >= YEAR(@FromDate)
          AND (tm.MonthValue < MONTH(@ToDate) OR (tm.MonthValue = MONTH(@ToDate) AND tm.YearValue <= YEAR(@ToDate)));

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
