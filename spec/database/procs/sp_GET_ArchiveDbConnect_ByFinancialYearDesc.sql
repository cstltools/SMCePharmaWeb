
create PROCEDURE [dbo].[sp_GET_ArchiveDbConnect_ByFinancialYearDesc]
    @FinancialYearDesc NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NULLIF(LTRIM(RTRIM(ISNULL(@FinancialYearDesc, N''))), N'') IS NULL
    BEGIN
        SELECT CAST(NULL AS NVARCHAR(MAX)) AS FinancialYearDesc,
               CAST(NULL AS NVARCHAR(MAX)) AS DataBaseName
        WHERE 1 = 0;
        RETURN;
    END

    SELECT FY AS FinancialYearDesc,
           DataBaseName
    FROM dbo.tblArcDBConnect
    WHERE FY = @FinancialYearDesc
    ORDER BY DataBaseName;
END
