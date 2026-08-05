
--------------------------------------------------
-- PROCEDURE: sp_Get_DAClaimDICApprovalListByRoute
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Get_DAClaimDICApprovalListByRoute
    @ComUnitId INT,
    @RouteId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT mas.DAClaimId,
           da.DACode,
           da.Name AS DAName,
           cunit.ComUnitCode,
           cunit.ComUnitName,
           mas.ApprovalStatus,
           mas.DICApprovalStatus,
           mas.EntryDate,
           mas.DICApprovalDate,
           STUFF((
               SELECT N', ' + ISNULL(cd.MarketName, N'')
               FROM dbo.tblDAClaimDetails cd WITH (NOLOCK)
               WHERE cd.DAClaimId = mas.DAClaimId
                 AND NULLIF(LTRIM(RTRIM(ISNULL(cd.MarketName, N''))), N'') IS NOT NULL
               FOR XML PATH(''), TYPE
           ).value('.', 'NVARCHAR(MAX)'), 1, 2, N'') AS MarketNames
    FROM dbo.tblDAClaimMaster mas WITH (NOLOCK)
    LEFT JOIN dbo.tblDAInfo da WITH (NOLOCK)
           ON mas.DaId = da.DAId
    LEFT JOIN dbo.tblCompanyUnit cunit WITH (NOLOCK)
           ON mas.ComUnitId = cunit.ComUnitId
    WHERE UPPER(LTRIM(RTRIM(ISNULL(mas.ApprovalStatus, N'')))) = N'APPROVED'
      AND UPPER(LTRIM(RTRIM(ISNULL(mas.DICApprovalStatus, N'')))) = N'APPROVED'
      AND mas.ComUnitId = @ComUnitId
      AND (@RouteId <= 0 OR mas.RouteId = @RouteId)
    ORDER BY mas.DAClaimId DESC;
END

