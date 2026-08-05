CREATE PROCEDURE [dbo].[sp_DeleteArchiveDCRData]
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
        -- Archive DCR data before deletion
        INSERT INTO dbo.tblDCRDeleteArchive
        (
            DcrId,
            DcrDate,
            TourTypeId,
            ChemberId,
            EntryBy,
            EntryDate,
            UpdateBy,
            UpdateDate,
            IsApproved,
            Remarks,
            DoctorId,
            DocTPDetailsId,
            GroupId,
            RegionId,
            AreaId,
            SubTerritoryId,
            TerritoryId,
            MarketId,
            IsNonEffectiveReason,
            ReasonId,
            EntryDate_Apps,
            ApprovalStatus,
            Latitude,
            Longitude,
            StreetAddress,
            DoctorProgramypeId,
            GroupName,
            RegionName,
            AreaName,
            TerritoryName,
            SubTerritoryName,
            MarketName,
            GroupCode_DCR,
            RegionCode_DCR,
            AreaCode_DCR,
            TerritoryCode_DCR,
            SubTerritoryCode_DCR,
            MarketCode_DCR,
            SmcTypeId_DCR,
            SMCType_DCR,
            DoctorType_DCR,
            DoctorTypeID_DCR,
            TypeDcr,
            ArchiveDate
        )
        SELECT
            d.DcrId,
            d.DcrDate,
            d.TourTypeId,
            d.ChemberId,
            d.EntryBy,
            d.EntryDate,
            d.UpdateBy,
            d.UpdateDate,
            d.IsApproved,
            d.Remarks,
            d.DoctorId,
            d.DocTPDetailsId,
            d.GroupId,
            d.RegionId,
            d.AreaId,
            d.SubTerritoryId,
            d.TerritoryId,
            d.MarketId,
            d.IsNonEffectiveReason,
            d.ReasonId,
            d.EntryDate_Apps,
            d.ApprovalStatus,
            d.Latitude,
            d.Longitude,
            d.StreetAddress,
            d.DoctorProgramypeId,
            d.GroupName,
            d.RegionName,
            d.AreaName,
            d.TerritoryName,
            d.SubTerritoryName,
            d.MarketName,
            d.GroupCode_DCR,
            d.RegionCode_DCR,
            d.AreaCode_DCR,
            d.TerritoryCode_DCR,
            d.SubTerritoryCode_DCR,
            d.MarketCode_DCR,
            d.SmcTypeId_DCR,
            d.SMCType_DCR,
            d.DoctorType_DCR,
            d.DoctorTypeID_DCR,
            d.TypeDcr,
            GETDATE() AS ArchiveDate
        FROM dbo.tbl_DCRInfo d
        WHERE d.DcrDate >= @FromDate
          AND d.DcrDate < DATEADD(DAY, 1, @ToDate);

        -- Archive DCR Detail data before deletion
        INSERT INTO dbo.tblDCRDetailDeleteArchive
        (
            DcrDetailID,
            DcrId,
            ProductId,
            Type,
            ProductQty,
            GWPromoQtyId,
            EmpInfoId,
            ArchiveDate
        )
        SELECT
            dd.DcrDetailID,
            dd.DcrId,
            dd.ProductId,
            dd.Type,
            dd.ProductQty,
            dd.GWPromoQtyId,
            dd.EmpInfoId,
            GETDATE() AS ArchiveDate
        FROM dbo.tbl_DcrDetails dd
        INNER JOIN dbo.tbl_DCRInfo d
            ON dd.DcrId = d.DcrId
        WHERE d.DcrDate >= @FromDate
          AND d.DcrDate < DATEADD(DAY, 1, @ToDate);

        -- Archive DCR Brand Details data before deletion
        INSERT INTO dbo.tblDCRBrandDetailsDeleteArchive
        (
            BrandDetailId,
            BrandId,
            DcrId,
            ArchiveDate
        )
        SELECT
            bd.BrandDetailId,
            bd.BrandId,
            bd.DcrId,
            GETDATE() AS ArchiveDate
        FROM dbo.tbl_DcrBrandDetails bd
        INNER JOIN dbo.tbl_DCRInfo d
            ON bd.DcrId = d.DcrId
        WHERE d.DcrDate >= @FromDate
          AND d.DcrDate < DATEADD(DAY, 1, @ToDate);

        -- Archive DCR Visited With Details data before deletion
        INSERT INTO dbo.tbl_DcrVisitedWithDetailsDeleteArchive
        (
            DcrVisitWithId,
            EmpInfoId,
            DcrId,
            ArchiveDate
        )
        SELECT
            vw.DcrVisitWithId,
            vw.EmpInfoId,
            vw.DcrId,
            GETDATE() AS ArchiveDate
        FROM dbo.tbl_DcrVisitedWithDetails vw
        INNER JOIN dbo.tbl_DCRInfo d
            ON vw.DcrId = d.DcrId
        WHERE d.DcrDate >= @FromDate
          AND d.DcrDate < DATEADD(DAY, 1, @ToDate);

        -- Delete DCR Visited With Details records
        DELETE vw
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_DcrVisitedWithDetails vw
        INNER JOIN SalesDisDB_SMC_NEWDB_Dynamic..tbl_DCRInfo d
            ON vw.DcrId = d.DcrId
        WHERE d.DcrDate >= @FromDate
          AND d.DcrDate < DATEADD(DAY, 1, @ToDate);

        -- Delete DCR Brand Details records
        DELETE bd
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_DcrBrandDetails bd
        INNER JOIN SalesDisDB_SMC_NEWDB_Dynamic..tbl_DCRInfo d
            ON bd.DcrId = d.DcrId
        WHERE d.DcrDate >= @FromDate
          AND d.DcrDate < DATEADD(DAY, 1, @ToDate);

        -- Delete DCR Detail records
        DELETE dd
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_DcrDetails dd
        INNER JOIN SalesDisDB_SMC_NEWDB_Dynamic..tbl_DCRInfo d
            ON dd.DcrId = d.DcrId
        WHERE d.DcrDate >= @FromDate
          AND d.DcrDate < DATEADD(DAY, 1, @ToDate);

        -- Delete DCR master records
        DELETE d
        FROM SalesDisDB_SMC_NEWDB_Dynamic..tbl_DCRInfo d
        WHERE d.DcrDate >= @FromDate
          AND d.DcrDate < DATEADD(DAY, 1, @ToDate);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH;
END;
